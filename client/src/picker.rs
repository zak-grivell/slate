use dioxus::prelude::*;
use nucleo_matcher::{
    Config, Matcher, Utf32String,
    pattern::{CaseMatching, Normalization, Pattern},
};
use slate_api::file_list;
use slate_shared::{RoutePath, TypstFileMetaData};
use std::cmp::Reverse;

use crate::{AppRoute, messages::use_receiver};

#[derive(Clone, Eq, PartialEq)]
struct SearchFile {
    data: TypstFileMetaData,
    path: String,
    path_utf32: Utf32String,
}

impl SearchFile {
    fn new(data: TypstFileMetaData) -> Self {
        let path = data.path.display().to_string();
        let path_utf32 = Utf32String::from(path.as_str());

        Self {
            data,
            path,
            path_utf32,
        }
    }
}

fn use_files() -> Signal<Vec<SearchFile>> {
    let mut files = use_signal(Vec::<SearchFile>::new);

    use_effect(move || {
        spawn(async move {
            match file_list().await {
                Ok(mut stream) => {
                    while let Some(chunk) = stream.next().await {
                        match chunk {
                            Ok(file) => {
                                files.write().push(SearchFile::new(file));
                            }
                            Err(err) => {
                                eprintln!("failed to read file chunk: {err}");
                            }
                        }
                    }
                }
                Err(err) => {
                    panic!("failed to list files: {err}");
                }
            }
        });
    });

    files
}

fn search_files(files: &[SearchFile], search: &str) -> Vec<TypstFileMetaData> {
    let search = search.trim();

    if search.is_empty() {
        return files
            .iter()
            .take(20)
            .map(|file| file.data.clone())
            .collect();
    }

    let mut matcher = Matcher::new(Config::DEFAULT.match_paths());

    let pattern = Pattern::parse(search, CaseMatching::Ignore, Normalization::Smart);

    let mut scored = files
        .iter()
        .filter_map(|file| {
            pattern
                .score(file.path_utf32.slice(..), &mut matcher)
                .map(|score| (score, file))
        })
        .collect::<Vec<_>>();

    scored.sort_by_key(|(score, _)| Reverse(*score));

    scored
        .into_iter()
        .take(20)
        .map(|(_, file)| file.data.clone())
        .collect()
}

#[component]
pub fn Picker() -> Element {
    let mut hidden = use_signal(|| true);
    let mut search_term = use_signal(String::new);
    let files = use_files();

    let matched_files = use_memo(move || search_files(&files.read(), &search_term.read()));

    use_receiver::<Event<KeyboardData>, _>(move |event: Event<KeyboardData>| match event.key() {
        Key::Escape => hidden.set(true),
        Key::Character(c) if c == "f" => hidden.set(false),
        _ => {}
    });

    rsx! {
        div { class: if hidden() { "hidden" } else { "\
                fixed left-1/2 top-20 z-50 w-[min(92vw,32rem)] -translate-x-1/2 \
                overflow-hidden rounded-md border border-base03 bg-base00 shadow-2xl \
                " },

            input {
                class: "\
                w-full border-b border-base03 bg-base01 px-2 py-1.5 \
                text-sm text-base05 placeholder-base04 outline-none \
                focus:bg-base00 \
                ",
                value: "{search_term}",
                placeholder: "search files",
                autofocus: true,
                oninput: move |e| search_term.set(e.value()),
            }

            ol { class: "max-h-72 overflow-y-auto text-sm",
                for file in matched_files.read().clone().into_iter() {
                    PickerItem { file }
                }
            }
        }
    }
}

#[component]
fn PickerItem(file: TypstFileMetaData) -> Element {
    rsx! {
    li {
        class: "border-b border-base01 last:border-b-0",

        Link {
            class: "
                block w-full cursor-pointer px-2 py-1 
                text-base05 
                hover:bg-base02 hover:text-base07
            ",
            to: AppRoute::FileViewer {
                path: RoutePath(file.path.clone())
            },
            "{file.path.display()}"
        }
    }    }
}
