use dioxus::{
    fullstack::{
        CborEncoding, JsonEncoding, JsonStream, Lazy, Streaming, WebSocketOptions, Websocket,
    },
    prelude::*,
};
use futures::{SinkExt, StreamExt, stream::FuturesUnordered};
use notify::{EventKind, RecursiveMode, Watcher};
use slate_bridge::TypstBridge;
use slate_shared::{ClientEvent, ServerEvent, TypstFileMetaData, TypstFilePath};
use std::{
    path::PathBuf,
    sync::OnceLock,
};
use tokio::sync::{Mutex, mpsc, watch};

static FOCUSED_FILE: OnceLock<watch::Sender<Option<TypstFilePath>>> = OnceLock::new();

fn focused_file() -> &'static watch::Sender<Option<TypstFilePath>> {
    FOCUSED_FILE.get_or_init(|| watch::channel(None).0)
}

pub async fn focus_file(axum::Json(path): axum::Json<TypstFilePath>) -> axum::http::StatusCode {
    focused_file().send_replace(Some(path));
    axum::http::StatusCode::NO_CONTENT
}

static TYPST_BRIDGE: Lazy<Mutex<TypstBridge>> = Lazy::new(async move || {
    println!("getting the bridge");
    let r = tokio::task::spawn_blocking(move || dioxus::Ok(Mutex::new(TypstBridge::default())))
        .await
        .unwrap();
    println!("Bridge made");
    r
});

pub fn find_typst_files(path: PathBuf) -> Vec<PathBuf> {
    if path.is_dir() {
        path.read_dir()
            .unwrap()
            .flat_map(|f| find_typst_files(f.unwrap().path()))
            .collect()
    } else if path.extension().is_some_and(|ext| ext == "typ") {
        vec![path]
    } else {
        vec![]
    }
}

pub async fn files_stream() -> ServerFnResult<Streaming<TypstFileMetaData, JsonEncoding>> {
    let root = PathBuf::from(".");
    let files = find_typst_files(root);

    let mut futures: FuturesUnordered<_> = files
        .into_iter()
        .map(|file| {
            tokio::task::spawn_blocking(move || -> Option<TypstFileMetaData> {
                let mut compiler = TYPST_BRIDGE.blocking_lock();

                let result = compiler.compile(&file).ok()?;

                let tags = result.metadata_query("tag").unwrap_or_default();

                let links = result.metadata_query("link").unwrap_or_default();

                Some(TypstFileMetaData {
                    path: TypstFilePath(file.to_path_buf()),
                    tags,
                    links,
                })
            })
        })
        .collect();

    Ok(JsonStream::spawn(|tx| async move {
        while let Some(result) = futures.next().await {
            if let Ok(Some(metadata)) = result {
                tx.unbounded_send(metadata).unwrap();
            }
        }
    }))
}

pub async fn get_colors() -> ServerFnResult<Vec<String>> {
    tokio::task::spawn_blocking(move || -> ServerFnResult<Vec<String>> {
        TYPST_BRIDGE
            .blocking_lock()
            .compile(&PathBuf::from("vault.typ"))
            .map_err(|file_error| ServerFnError::ServerError {
                message: file_error.to_string(),
                code: file_error.status_code(),
                details: None,
            })?
            .metadata_query("theme")
            .map_err(|_| ServerFnError::ServerError {
                message: "missing theme metadata".to_string(),
                code: 500,
                details: None,
            })
    })
    .await
    .map_err(|err| ServerFnError::ServerError {
        message: err.to_string(),
        code: 500,
        details: None,
    })?
}

pub async fn render(path: PathBuf) -> ServerFnResult<String> {
    tokio::task::spawn_blocking(move || {
        TYPST_BRIDGE
            .blocking_lock()
            .compile(&path)
            .map_err(|file_error| ServerFnError::ServerError {
                message: file_error.to_string(),
                code: file_error.status_code(),
                details: None,
            })?
            .render()
            .map_err(|compile_error| ServerFnError::ServerError {
                message: compile_error.to_string(),
                code: 422,
                details: None,
            })
    })
    .await
    .map_err(|err| ServerFnError::ServerError {
        message: err.to_string(),
        code: 500,
        details: None,
    })?
}

pub async fn file_watcher(
    path: Option<TypstFilePath>,
    options: WebSocketOptions,
) -> ServerFnResult<Websocket<ClientEvent, ServerEvent, CborEncoding>> {
    Ok(options.on_upgrade(move |socket| async move {
        let (tx, mut rx) = mpsc::channel::<PathBuf>(5);
        let (mut sender, mut receiver) = socket.split();
        let mut focus_rx = focused_file().subscribe();
        let mut following = path.is_none();
        let mut current = path.or_else(|| focus_rx.borrow_and_update().clone());
        let mut watcher = match notify::recommended_watcher(move |res: notify::Result<notify::Event>| {
            if let Ok(event) = res
                && matches!(event.kind, EventKind::Modify(_) | EventKind::Create(_))
                && let Some(path) = event.paths.first()
            {
                let _ = tx.try_send(path.clone());
            }
        }) {
            Ok(watcher) => watcher,
            Err(err) => { eprintln!("failed to create file watcher: {err}"); return; }
        };
        loop {
            if let Some(path) = &current {
                if let Err(err) = watcher.watch(path.as_local(), RecursiveMode::NonRecursive) {
                    eprintln!("failed to watch {}: {err}", path.display());
                }
                if sender.send(ServerEvent::FileUpdate(render(path.as_local().to_path_buf()).await)).await.is_err() {
                    return;
                }
            } else if sender.send(ServerEvent::FileUpdate(Ok("<h2>Waiting for an editor document</h2>".into()))).await.is_err() {
                return;
            }
            let next = loop {
                tokio::select! {
                    event = receiver.next() => {
                        match event {
                            Some(Ok(ClientEvent::FileMoved(path))) => {
                                following = false;
                                break Some(path);
                            }
                            Some(Ok(ClientEvent::Follow)) => {
                                following = true;
                                break focus_rx.borrow_and_update().clone();
                            }
                            _ => return,
                        }
                    }
                    changed = focus_rx.changed() => {
                        if changed.is_err() { return; }
                        let focused = focus_rx.borrow_and_update().clone();
                        if following { break focused; }
                    }
                    changed = rx.recv() => {
                        if changed.is_none() { return; }
                        break current.clone();
                    }
                }
            };
            if let Some(path) = &current {
                let _ = watcher.unwatch(path.as_local());
            }
            current = next;
        }
    }))
}
