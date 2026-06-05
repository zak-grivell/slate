use dioxus::{
    fullstack::{
        CborEncoding, JsonEncoding, JsonStream, Lazy, Streaming, WebSocketOptions, Websocket,
    },
    prelude::*,
};
use futures::{SinkExt, StreamExt, stream::FuturesUnordered};
use notify::{Event, RecursiveMode, Result, Watcher};
use slate_bridge::TypstBridge;
use slate_shared::{ClientEvent, RoutePath, ServerEvent, TypstFileMetaData};
use std::path::PathBuf;
use tokio::sync::{Mutex, mpsc};

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
                    path: file.to_path_buf(),
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
    path: RoutePath,
    options: WebSocketOptions,
) -> ServerFnResult<Websocket<ClientEvent, ServerEvent, CborEncoding>> {
    println!("ws recived");

    Ok(options.on_upgrade(move |socket| async move {
        println!("ws updgraded");

        let (tx, mut rx) = mpsc::channel::<Result<Event>>(5);
        let (mut sender, mut reciver) = socket.split();

        let mut watcher = notify::recommended_watcher(move |res| {
            let _ = tx.blocking_send(res);
        })
        .unwrap();

        println!("started trying to send {:?}", path.clone());

        sender
            .send(ServerEvent::FileUpdate(render(path.0.clone()).await))
            .await
            .unwrap();

        let worker = tokio::spawn(async move {
            while let Some(Ok(event)) = rx.recv().await {
                if let Some(path) = event.paths.first() {
                    let _ = sender
                        .send(ServerEvent::FileUpdate(render(path.clone()).await))
                        .await;
                }
            }
        });

        let mut last_path = path;

        watcher
            .watch(&last_path.0, RecursiveMode::NonRecursive)
            .unwrap();

        while let Some(Ok(msg)) = reciver.next().await {
            match msg {
                ClientEvent::FileMoved(p) => {
                    watcher.unwatch(&last_path.0).unwrap();

                    watcher.watch(&p.0, RecursiveMode::NonRecursive).unwrap();

                    last_path = p;
                }
            }
        }

        worker.abort();
    }))
}
