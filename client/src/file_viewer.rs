use crate::picker::Picker;
use crate::theme::Base16Theme;
use dioxus::fullstack::{WebSocketOptions, use_websocket};
use dioxus::prelude::*;
use slate_api::file_watcher;
use slate_shared::{RoutePath, ServerEvent};

#[component]
fn RenderedDoccument(inital_path: RoutePath) -> Element {
    let mut socket = use_websocket(move || {
        println!("staring ws");
        file_watcher(inital_path.clone(), WebSocketOptions::new())
    });

    let mut content: Signal<ServerFnResult<String>> =
        use_signal(|| Ok(String::from("<h2>Loading</h2>")));

    use_future(move || async move {
        while let Ok(msg) = socket.recv().await {
            println!("Message recived {:?}", msg);
            match msg {
                ServerEvent::FileUpdate(res) => content.set(res),
            }
        }
    });

    rsx! {
        match &*content.read() {
            Ok(html) => rsx! {
                div {
                    dangerous_inner_html: "{html}"
                }
            },

            Err(err) => rsx! {
                div {
                    h2 { class: "font-bold", "Error rendering document" }
                    p { "{err.to_string()}" }
                }
            },
        }
    }
}

#[component]
pub fn FileViewer(path: RoutePath) -> Element {
    rsx! {
        Picker {}
        Base16Theme {}

        main {
            class: "p-0 m-0 h-screen w-screen bg-base00 overflow-hidden",
            background_image: "radial-gradient(var(--base03) 1px, transparent 1px)",
            background_size: "22px 22px",

            div {
                class: "
                    overflow-y-auto
                    h-full
                ",
                article { class: "
                        mt-0 min-[42rem]:mt-5
                        mb-0 min-[42rem]:mb-20

                        min-h-screen min-[42rem]:min-h-dvh
                                                   
                        prose
                        max-w-2xl
                        mx-auto
                        bg-base01
                        px-14 py-3
                        border border-base02
                        shadow-xl
                        rounded-none min-[42rem]:rounded-2xl
                    ",
                    RenderedDoccument {
                        inital_path: path
                    }
                }
            }
        }
    }
}
