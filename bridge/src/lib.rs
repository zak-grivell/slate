use blake3::{self};
use notify::{RecommendedWatcher, RecursiveMode::NonRecursive, Watcher, recommended_watcher};
use std::{
    borrow::Cow,
    collections::{HashMap, HashSet, hash_map::Entry},
    fs,
    path::{Path, PathBuf},
    sync::{Arc, Mutex},
};
use thiserror::Error;
use typst::{
    Document,
    diag::{FileError, FileResult},
    foundations::{Bytes, Label, Str},
    introspection::MetadataElem,
    syntax::{FileId, Source, VirtualPath},
    utils::PicoStr,
};
use typst_as_lib::{
    TypstAsLibError, TypstEngine, TypstTemplateCollection, file_resolver::FileResolver,
    typst_kit_options::TypstKitFontOptions,
};
use typst_html::HtmlDocument;

#[derive(Debug, Clone)]
pub struct CompiledDoccument {
    input_hash: blake3::Hash,
    doc: Result<HtmlDocument, TypstAsLibError>,
}

impl CompiledDoccument {
    pub fn render(&self) -> Result<String, TypstAsLibError> {
        typst_html::html(self.doc.as_ref().map_err(Clone::clone)?).map_err(|errors| {
            TypstAsLibError::Unspecified(
                errors
                    .into_iter()
                    .map(|err| err.message)
                    .collect::<Vec<_>>()
                    .join("\n")
                    .into(),
            )
        })
    }

    pub fn metadata_query(&self, s: &str) -> Result<Vec<String>, TypstAsLibError> {
        let label = Label::new(PicoStr::get(s).unwrap()).unwrap();
        let selector = typst::foundations::Selector::Label(label);

        Ok(self
            .doc
            .as_ref()
            .map_err(Clone::clone)?
            .introspector()
            .query(&selector)
            .into_iter()
            .filter_map(|elem| {
                let meta = elem.to_packed::<MetadataElem>()?;
                let s = meta.value.clone().cast::<Str>().ok()?;
                Some(s.as_str().to_owned())
            })
            .collect())
    }
}

#[derive(Debug, Error)]
pub enum FinalFileError {
    #[error("file not found: {path}")]
    NotFound {
        path: PathBuf,
        #[source]
        source: std::io::Error,
    },

    #[error("io error while reading {path}: {source}")]
    Io {
        path: PathBuf,
        #[source]
        source: std::io::Error,
    },

    #[error("not typst file")]
    InvalidFileType { path: PathBuf },
}

impl FinalFileError {
    pub fn status_code(&self) -> u16 {
        match self {
            FinalFileError::NotFound { .. } => 404,
            FinalFileError::InvalidFileType { .. } => 415,

            FinalFileError::Io { source, .. } => match source.kind() {
                std::io::ErrorKind::PermissionDenied => 403,
                std::io::ErrorKind::InvalidInput
                | std::io::ErrorKind::InvalidData
                | std::io::ErrorKind::Unsupported => 400,
                std::io::ErrorKind::TimedOut => 504,
                std::io::ErrorKind::AlreadyExists => 409,
                _ => 500,
            },
        }
    }
}

fn read_typst_file(path: impl AsRef<std::path::Path>) -> Result<String, FinalFileError> {
    let path = path.as_ref();

    match path.extension().and_then(|ext| ext.to_str()) {
        Some("typ") => Ok(()),
        _ => Err(FinalFileError::InvalidFileType {
            path: path.to_path_buf(),
        }),
    }?;

    std::fs::read_to_string(path).map_err(|err| {
        if err.kind() == std::io::ErrorKind::NotFound {
            FinalFileError::NotFound {
                path: path.to_path_buf(),
                source: err,
            }
        } else {
            FinalFileError::Io {
                path: path.to_path_buf(),
                source: err,
            }
        }
    })
}

pub struct TypstBridge {
    engine: TypstEngine<TypstTemplateCollection>,
    cache: HashMap<PathBuf, CompiledDoccument>,
}

impl TypstBridge {
    pub fn compile(&mut self, file: &PathBuf) -> Result<&CompiledDoccument, FinalFileError> {
        let content = read_typst_file(file)?;

        let current_hash = blake3::hash(content.as_bytes());

        match self.cache.entry(file.clone()) {
            Entry::Vacant(entry) => {
                println!("Cache miss generating");

                Ok(entry.insert(CompiledDoccument {
                    input_hash: current_hash,
                    doc: self.engine.compile(file.to_string_lossy().as_ref()).output,
                }))
            }

            Entry::Occupied(mut entry) => {
                if entry.get().input_hash != current_hash {
                    println!("regenerating");

                    *entry.get_mut() = CompiledDoccument {
                        input_hash: current_hash,
                        doc: self.engine.compile(file.to_string_lossy().as_ref()).output,
                    };
                }

                Ok(entry.into_mut())
            }
        }
    }
}

struct SmartFileResolver {
    watcher: Arc<Mutex<RecommendedWatcher>>,
    cache: Arc<Mutex<HashMap<FileId, Vec<u8>>>>,
    watching: Arc<Mutex<HashSet<FileId>>>,
    root: PathBuf,
    local_package_root: Option<PathBuf>,
}

impl FileResolver for SmartFileResolver {
    fn resolve_binary(
        &self,
        id: FileId,
    ) -> typst::diag::FileResult<std::borrow::Cow<'_, typst::foundations::Bytes>> {
        let b = self.resolve_bytes(id)?;
        Ok(Cow::Owned(Bytes::new(b)))
    }

    fn resolve_source(
        &self,
        id: FileId,
    ) -> typst::diag::FileResult<std::borrow::Cow<'_, typst::syntax::Source>> {
        let bytes = self.resolve_bytes(id)?;
        let contents = std::str::from_utf8(&bytes).map_err(|_| FileError::InvalidUtf8)?;
        let contents = contents.trim_start_matches('\u{feff}');
        let source = Source::new(id, contents.to_owned());
        Ok(Cow::Owned(source))
    }
}

fn to_stupid_typst_id(path: PathBuf) -> FileId {
    FileId::new(None, VirtualPath::new(path)) // this is going to panic imma kms
}

pub const DEFAULT_PACKAGES_SUBDIR: &str = "typst/packages";

impl SmartFileResolver {
    fn resolve_file_id(&self, id: FileId) -> Result<PathBuf, FileError> {
        let Self {
            root,
            local_package_root,
            ..
        } = self;

        let dir: Cow<Path> = if let Some(package) = id.package() {
            let data_dir = if let Some(data_dir) = local_package_root {
                Cow::Borrowed(data_dir)
            } else if let Some(data_dir) = dirs::data_dir() {
                Cow::Owned(data_dir.join(DEFAULT_PACKAGES_SUBDIR))
            } else {
                panic!("No data dir set!");
            };
            let subdir = Path::new(package.namespace.as_str())
                .join(package.name.as_str())
                .join(package.version.to_string());
            Cow::Owned(data_dir.join(subdir))
        } else {
            Cow::Borrowed(root)
        };

        id.vpath()
            .resolve(&dir)
            .ok_or_else(|| FileError::NotFound(dir.to_path_buf()))
    }

    fn resolve_bytes(&self, id: FileId) -> FileResult<Vec<u8>> {
        // https://github.com/typst/typst/blob/16736feb13eec87eb9ca114deaeb4f7eeb7409d2/crates/typst-kit/src/package.rs#L102C16-L102C38

        let path = self.resolve_file_id(id)?;

        match self.cache.lock().unwrap().entry(id) {
            Entry::Occupied(entry) => Ok(entry.get().clone()),
            Entry::Vacant(entry) => {
                self.watch(id);

                let content =
                    std::fs::read(&path).map_err(|error| FileError::from_io(error, &path))?;

                let q = entry.insert(content);

                Ok(q.clone())
            }
        }
    }

    fn watch(&self, id: FileId) -> Option<bool> {
        let mut w = self.watching.lock().unwrap();

        if !w.contains(&id) {
            w.insert(id);

            Some(
                self.watcher
                    .lock()
                    .unwrap()
                    .watch(
                        &id.vpath()
                            .resolve(&PathBuf::from("."))
                            .expect("error with virtual"),
                        NonRecursive,
                    )
                    .is_ok(),
            )
        } else {
            None
        }
    }

    fn new(root: PathBuf) -> Self {
        let cache = Arc::new(Mutex::new(HashMap::new()));

        let c = cache.clone();
        let mut root = root.clone();

        // trailing slash is necessary for resolve function, which is, what this 'hack' does
        // https://users.rust-lang.org/t/trailing-in-paths/43166/9
        root.push("");

        let loc = Box::new(fs::canonicalize(&root).expect("could not normalise root"));

        Self {
            root,
            local_package_root: None,
            watcher: Arc::new(Mutex::new(
                recommended_watcher(move |event: Result<notify::Event, notify::Error>| {
                    let Ok(e) = event else { return };

                    let mut c = c.lock().unwrap();

                    for p in e.paths {
                        let Ok(local) = p.strip_prefix(*loc.clone()) else {
                            println!("could not remove prefix {:?}", loc);
                            continue;
                        };

                        let i = to_stupid_typst_id(local.to_path_buf());

                        c.remove(&i);
                    }
                })
                .unwrap(),
            )),
            cache,
            watching: Arc::new(Mutex::new(HashSet::new())),
        }
    }
}

impl Default for TypstBridge {
    fn default() -> Self {
        TypstBridge {
            engine: TypstEngine::builder()
                .add_file_resolver(SmartFileResolver::new(PathBuf::from(".")))
                .with_package_file_resolver()
                .search_fonts_with(TypstKitFontOptions::default())
                .build(),
            cache: HashMap::new(),
        }
    }
}
