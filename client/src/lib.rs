use std::path::PathBuf;

use dioxus::prelude::*;

mod file_viewer;
mod messages;
mod picker;
mod route_path;
mod theme;

use file_viewer::FileViewer;
use messages::use_messenger;
use slate_shared::TypstFilePath;

#[component]
fn KeyboardShortcutManager(children: Element) -> Element {
    let mut messenger = use_messenger::<Event<KeyboardData>>();

    rsx! {
        div {
            tabindex: 0,
            onkeydown: move |event| {
                messenger.send(event);
            },
            {children}
        }
    }
}

#[derive(Clone, Debug, PartialEq, Routable)]
pub enum AppRoute {
    #[redirect("/", || AppRoute::FileViewer {
        path: TypstFilePath::from(PathBuf::from("vault.typ")),
    })]
    #[route("/file/:..path")]
    FileViewer { path: TypstFilePath },
}

#[component]
pub fn App() -> Element {
    rsx! {
        KeyboardShortcutManager { Router::<AppRoute> {
        } }
    }
}
