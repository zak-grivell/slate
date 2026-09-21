use serde_json::{Value, json};
use std::{
    collections::HashMap,
    io,
    path::{Path, PathBuf},
    process::Stdio,
};
use tokio::{
    io::{AsyncRead, AsyncReadExt, AsyncWrite, AsyncWriteExt, BufReader, BufWriter},
    process::{Child, Command},
    sync::mpsc,
};
use url::Url;

use crate::spawn_preview;

pub async fn run(port: u16, open: bool) -> io::Result<()> {
    let mut tinymist = Command::new("tinymist")
        .stdin(Stdio::piped())
        .stdout(Stdio::piped())
        .stderr(Stdio::inherit())
        .spawn()?;
    let tinymist_stdin = tinymist
        .stdin
        .take()
        .ok_or_else(|| io::Error::other("missing Tinymist stdin"))?;
    let tinymist_stdout = tinymist
        .stdout
        .take()
        .ok_or_else(|| io::Error::other("missing Tinymist stdout"))?;

    let mut editor_out = BufWriter::new(tokio::io::stdout());
    let mut tinymist_in = BufWriter::new(tinymist_stdin);
    let (editor_tx, mut editor_rx) = mpsc::channel(32);
    let (tinymist_tx, mut tinymist_rx) = mpsc::channel(32);
    tokio::spawn(read_messages(BufReader::new(tokio::io::stdin()), editor_tx));
    tokio::spawn(read_messages(BufReader::new(tinymist_stdout), tinymist_tx));
    let mut documents = HashMap::<String, String>::new();
    let mut preview: Option<Child> = None;

    loop {
        tokio::select! {
            editor_message = editor_rx.recv() => {
                let Some(message) = editor_message else { break };
                let message = message?;
                let value: Value = serde_json::from_slice(&message)
                    .map_err(|err| io::Error::new(io::ErrorKind::InvalidData, err))?;

                update_documents(&mut documents, &value);

                if preview.is_none() && value.get("method").and_then(Value::as_str) == Some("initialize") {
                    if let Some(root) = workspace_root(&value) {
                        preview = match spawn_preview(&root, port, open) {
                            Ok(child) => Some(child),
                            Err(err) => {
                                eprintln!("slate lsp: failed to start preview: {err}");
                                None
                            }
                        };
                    }
                }

                if value.get("method").and_then(Value::as_str) == Some("textDocument/definition") {
                    if let Some(response) = link_definition_response(&value, &documents) {
                        write_value(&mut editor_out, &response).await?;
                        continue;
                    }
                }

                write_message(&mut tinymist_in, &message).await?;
            }
            server_message = tinymist_rx.recv() => {
                let Some(message) = server_message else { break };
                let message = message?;
                write_message(&mut editor_out, &message).await?;
            }
        }
    }

    if let Some(mut child) = preview {
        let _ = child.kill().await;
    }
    let _ = tinymist.kill().await;
    Ok(())
}

async fn read_messages<R: AsyncRead + Unpin>(
    mut reader: R,
    sender: mpsc::Sender<io::Result<Vec<u8>>>,
) {
    loop {
        match read_message(&mut reader).await {
            Ok(Some(message)) => {
                if sender.send(Ok(message)).await.is_err() {
                    return;
                }
            }
            Ok(None) => return,
            Err(err) => {
                let _ = sender.send(Err(err)).await;
                return;
            }
        }
    }
}

async fn read_message<R: AsyncRead + Unpin>(reader: &mut R) -> io::Result<Option<Vec<u8>>> {
    let mut header = Vec::new();
    let mut byte = [0u8; 1];
    while !header.ends_with(b"\r\n\r\n") {
        match reader.read_exact(&mut byte).await {
            Ok(_) => header.push(byte[0]),
            Err(err) if err.kind() == io::ErrorKind::UnexpectedEof && header.is_empty() => {
                return Ok(None);
            }
            Err(err) => return Err(err),
        }
    }

    let header = String::from_utf8_lossy(&header);
    let length = header
        .lines()
        .find_map(|line| line.strip_prefix("Content-Length:"))
        .and_then(|length| length.trim().parse::<usize>().ok())
        .ok_or_else(|| io::Error::new(io::ErrorKind::InvalidData, "missing Content-Length"))?;
    let mut body = vec![0; length];
    reader.read_exact(&mut body).await?;
    Ok(Some(body))
}

async fn write_message<W: AsyncWrite + Unpin>(writer: &mut W, body: &[u8]) -> io::Result<()> {
    writer
        .write_all(format!("Content-Length: {}\r\n\r\n", body.len()).as_bytes())
        .await?;
    writer.write_all(body).await?;
    writer.flush().await
}

async fn write_value<W: AsyncWrite + Unpin>(writer: &mut W, value: &Value) -> io::Result<()> {
    let body = serde_json::to_vec(value).map_err(io::Error::other)?;
    write_message(writer, &body).await
}

fn workspace_root(message: &Value) -> Option<PathBuf> {
    let params = message.get("params")?;
    let uri = params.get("rootUri").and_then(Value::as_str).or_else(|| {
        params
            .get("workspaceFolders")?
            .as_array()?
            .first()?
            .get("uri")?
            .as_str()
    })?;
    Url::parse(uri).ok()?.to_file_path().ok()
}

fn update_documents(documents: &mut HashMap<String, String>, message: &Value) {
    match message.get("method").and_then(Value::as_str) {
        Some("textDocument/didOpen") => {
            let Some(document) = message.pointer("/params/textDocument") else {
                return;
            };
            let (Some(uri), Some(text)) = (
                document.get("uri").and_then(Value::as_str),
                document.get("text").and_then(Value::as_str),
            ) else {
                return;
            };
            documents.insert(uri.to_owned(), text.to_owned());
        }
        Some("textDocument/didChange") => {
            let Some(uri) = message
                .pointer("/params/textDocument/uri")
                .and_then(Value::as_str)
            else {
                return;
            };
            let Some(changes) = message
                .pointer("/params/contentChanges")
                .and_then(Value::as_array)
            else {
                return;
            };
            let Some(text) = documents.get_mut(uri) else {
                return;
            };
            for change in changes {
                let Some(replacement) = change.get("text").and_then(Value::as_str) else {
                    continue;
                };
                if let Some(range) = change.get("range") {
                    let Some(start) = position_offset(text, &range["start"]) else {
                        continue;
                    };
                    let Some(end) = position_offset(text, &range["end"]) else {
                        continue;
                    };
                    if start <= end && end <= text.len() {
                        text.replace_range(start..end, replacement);
                    }
                } else {
                    *text = replacement.to_owned();
                }
            }
        }
        Some("textDocument/didClose") => {
            if let Some(uri) = message
                .pointer("/params/textDocument/uri")
                .and_then(Value::as_str)
            {
                documents.remove(uri);
            }
        }
        _ => {}
    }
}

fn link_definition_response(request: &Value, documents: &HashMap<String, String>) -> Option<Value> {
    let id = request.get("id")?.clone();
    let uri = request.pointer("/params/textDocument/uri")?.as_str()?;
    let position = request.pointer("/params/position")?;
    let source_path = Url::parse(uri).ok()?.to_file_path().ok()?;
    let text = documents
        .get(uri)
        .cloned()
        .or_else(|| std::fs::read_to_string(&source_path).ok())?;
    let offset = position_offset(&text, position)?;
    let (start, end, link) = quoted_typst_link(&text, offset)?;
    let target = source_path
        .parent()
        .unwrap_or_else(|| Path::new("."))
        .join(link);
    let target = target.canonicalize().ok()?;
    if target.extension().and_then(|ext| ext.to_str()) != Some("typ") {
        return None;
    }

    let target_uri = Url::from_file_path(target).ok()?.to_string();
    Some(json!({
        "jsonrpc": "2.0",
        "id": id,
        "result": {
            "originSelectionRange": {
                "start": offset_position(&text, start),
                "end": offset_position(&text, end),
            },
            "targetUri": target_uri,
            "targetRange": {
                "start": { "line": 0, "character": 0 },
                "end": { "line": 0, "character": 0 },
            },
            "targetSelectionRange": {
                "start": { "line": 0, "character": 0 },
                "end": { "line": 0, "character": 0 },
            }
        }
    }))
}

fn quoted_typst_link(text: &str, offset: usize) -> Option<(usize, usize, &str)> {
    let line_start = text[..offset].rfind('\n').map_or(0, |index| index + 1);
    let line_end = text[offset..]
        .find('\n')
        .map_or(text.len(), |index| offset + index);
    let line = &text[line_start..line_end];
    let local_offset = offset - line_start;

    let mut quote_start = None;
    for (index, character) in line.char_indices() {
        if character != '"' || is_escaped(line, index) {
            continue;
        }
        match quote_start {
            None => quote_start = Some(index),
            Some(start) => {
                if local_offset >= start && local_offset <= index {
                    let value = &line[start + 1..index];
                    if value.ends_with(".typ") {
                        return Some((line_start + start + 1, line_start + index, value));
                    }
                }
                quote_start = None;
            }
        }
    }
    None
}

fn is_escaped(text: &str, index: usize) -> bool {
    text[..index]
        .bytes()
        .rev()
        .take_while(|byte| *byte == b'\\')
        .count()
        % 2
        == 1
}

fn position_offset(text: &str, position: &Value) -> Option<usize> {
    let target_line = position.get("line")?.as_u64()? as usize;
    let target_character = position.get("character")?.as_u64()? as usize;
    let mut line_start = 0;
    for _ in 0..target_line {
        line_start += text[line_start..].find('\n')? + 1;
    }
    let line_end = text[line_start..]
        .find('\n')
        .map_or(text.len(), |index| line_start + index);
    let line = &text[line_start..line_end];
    let mut utf16 = 0;
    for (byte, character) in line.char_indices() {
        if utf16 >= target_character {
            return Some(line_start + byte);
        }
        utf16 += character.len_utf16();
    }
    (utf16 == target_character).then_some(line_end)
}

fn offset_position(text: &str, offset: usize) -> Value {
    let prefix = &text[..offset];
    let line = prefix.bytes().filter(|byte| *byte == b'\n').count();
    let line_start = prefix.rfind('\n').map_or(0, |index| index + 1);
    let character = text[line_start..offset].encode_utf16().count();
    json!({ "line": line, "character": character })
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn finds_note_link_under_cursor() {
        let text = "See #note(\"./other.typ\") today";
        let offset = text.find("other").unwrap() + 2;
        assert_eq!(quoted_typst_link(text, offset).unwrap().2, "./other.typ");
    }

    #[test]
    fn converts_utf16_positions() {
        let text = "a😀b\nsecond";
        assert_eq!(
            position_offset(text, &json!({"line": 0, "character": 3})),
            Some(5)
        );
        assert_eq!(
            position_offset(text, &json!({"line": 1, "character": 2})),
            Some(9)
        );
    }
}
