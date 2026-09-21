use dioxus::{
    fullstack::{CborEncoding, JsonEncoding, Streaming, WebSocketOptions, Websocket},
    prelude::*,
};
use slate_shared::{ClientEvent, ServerEvent, TypstFileMetaData, TypstFilePath};
// use slate_server::{ClientEvent, ServerEvent};

#[server]
pub async fn file_list() -> ServerFnResult<Streaming<TypstFileMetaData, JsonEncoding>> {
    slate_server::files_stream().await
}

#[server]
pub async fn get_colors() -> ServerFnResult<Vec<String>> {
    slate_server::get_colors().await
}

// #[server]
// pub async fn render(path: PathBuf) -> ServerFnResult<String> {
//     slate_server::render(path).await
// }

#[get("/ws/*path")]
pub async fn file_watcher(
    path: TypstFilePath,
    options: WebSocketOptions,
) -> ServerFnResult<Websocket<ClientEvent, ServerEvent, CborEncoding>> {
    println!("file stuff");
    slate_server::file_watcher(path, options).await
}
