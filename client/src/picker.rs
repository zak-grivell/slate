use dioxus::{document::document, prelude::*};
use nucleo_matcher::{
    Config, Matcher, Utf32String,
    pattern::{CaseMatching, Normalization, Pattern},
};
use slate_api::file_list;
use slate_shared::TypstFileMetaData;
use std::{cmp::Reverse, rc::Rc};

use crate::{AppRoute, messages::use_receiver};

#[derive(Clone, Eq, PartialEq)]
struct SearchFile {
    data: TypstFileMetaData,
    path: String,
    path_utf32: Utf32String,
}

impl SearchFile {
    fn new(data: TypstFileMetaData) -> Self {
        let path = data.path.display();
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
    let mut input = use_signal(|| None::<Rc<MountedData>>);

    use_receiver::<Event<KeyboardData>, _>(move |event: Event<KeyboardData>| match event.key() {
        Key::Escape => hidden.set(true),
        Key::Character(c) if c == "f" => {
            spawn(async move {
                let input = input().unwrap();
                input.set_focus(true).await.unwrap();
            });

            hidden.set(false);
        }
        _ => {}
    });

    let mut selected = use_signal(move || {
        let _ = matched_files();

        0
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
                onmounted: move |event| {
                    input.set(Some(event.data()));
                },
                onkeydown: move |e: Event<KeyboardData>| {
                    match e.key() {
                        Key::Enter => {
                            let Some(selection) = matched_files().get(selected()).cloned() else {
                                return
                            };

                            navigator()
                                .push(AppRoute::FileViewer {
                                    path: selection.path.clone(),
                                });
                            hidden.set(true);
                        }
                        Key::ArrowUp => {
                            let files = matched_files();
                            selected.set(((selected() + files.len()) - 1) % files.len())
                        }
                        Key::ArrowDown => {
                            let files = matched_files();
                            selected.set((selected() + 1) % files.len())
                        }
                        _ => {}
                    }
                },
            }

            ol { class: "max-h-72 overflow-y-auto text-sm",
                for (i, file) in matched_files.read().cloned().into_iter().enumerate() {
                    PickerItem { file, selected: i == selected() }
                }
            }
        }
    }
}

#[component]
fn PickerItem(file: TypstFileMetaData, selected: bool) -> Element {
    rsx! {
        li { class: "border-b border-base01 last:border-b-0",

            Link {
                class: format!(
                    "block w-full cursor-pointer px-2 py-1 hover:bg-base02 hover:text-base07 {}",
                    if selected { "bg-base02 text-base07" } else { "text-base05" },
                ),
                to: AppRoute::FileViewer {
                    path: file.path.clone(),
                },
                if selected {
                    "> {file.path.display()}"
                } else {
                    "  {file.path.display()}"
                }
            }
        }
    }
}
