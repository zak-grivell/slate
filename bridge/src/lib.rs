use blake3::{self};
use std::{
    collections::{HashMap, hash_map::Entry},
    path::PathBuf,
};
use thiserror::Error;
use typst::{
    Document,
    foundations::{Label, Str},
    introspection::MetadataElem,
    utils::PicoStr,
};
use typst_as_lib::{
    TypstAsLibError, TypstEngine, TypstTemplateCollection, typst_kit_options::TypstKitFontOptions,
};
use typst_html::HtmlDocument;

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
pub enum FileError {
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

impl FileError {
    pub fn status_code(&self) -> u16 {
        match self {
            FileError::NotFound { .. } => 404,
            FileError::InvalidFileType { .. } => 415,

            FileError::Io { source, .. } => match source.kind() {
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

fn read_typst_file(path: impl AsRef<std::path::Path>) -> Result<String, FileError> {
    let path = path.as_ref();

    match path.extension().and_then(|ext| ext.to_str()) {
        Some("typ") => Ok(()),
        _ => Err(FileError::InvalidFileType {
            path: path.to_path_buf(),
        }),
    }?;

    std::fs::read_to_string(path).map_err(|err| {
        if err.kind() == std::io::ErrorKind::NotFound {
            FileError::NotFound {
                path: path.to_path_buf(),
                source: err,
            }
        } else {
            FileError::Io {
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
    pub fn compile(&mut self, file: &PathBuf) -> Result<&CompiledDoccument, FileError> {
        let content = read_typst_file(file)?;

        let current_hash = blake3::hash(content.as_bytes());

        Ok(match self.cache.entry(file.clone()) {
            Entry::Vacant(entry) => entry.insert(CompiledDoccument {
                input_hash: current_hash,
                doc: self.engine.compile(file.to_string_lossy().as_ref()).output,
            }),

            Entry::Occupied(mut entry) => {
                if entry.get().input_hash != current_hash {
                    entry.get_mut().input_hash = current_hash;
                    entry.get_mut().doc =
                        self.engine.compile(file.to_string_lossy().as_ref()).output
                }

                entry.into_mut()
            }
        })
    }
}

impl Default for TypstBridge {
    fn default() -> Self {
        TypstBridge {
            engine: TypstEngine::builder()
                .with_file_system_resolver("")
                .with_package_file_resolver()
                .search_fonts_with(TypstKitFontOptions::default())
                .build(),
            cache: HashMap::new(),
        }
    }
}
