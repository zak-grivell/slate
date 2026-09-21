use dioxus::prelude::*;
use dioxus_router::{FromRouteSegments, ToRouteSegments};
use serde::{Deserialize, Serialize};
use std::path::{self, PathBuf};

#[derive(Debug, Serialize, Deserialize, Clone, PartialEq, Eq)]
pub struct TypstFileMetaData {
    pub tags: Vec<String>,
    pub links: Vec<String>,
    pub path: TypstFilePath,
}
use std::{fmt, path::Path};

#[derive(Clone, Debug, PartialEq, Eq, Serialize, Deserialize)]
pub struct TypstFilePath(pub PathBuf);

impl TypstFilePath {
    pub fn as_path(&self) -> &Path {
        &self.0
    }

    pub fn into_path_buf(self) -> PathBuf {
        self.0
    }

    pub fn as_local(&self) -> &Path {
        self.0.strip_prefix("/").unwrap_or(&self.0)
    }

    pub fn display(&self) -> String {
        self.0
            .components()
            .filter_map(|component| match component {
                path::Component::Prefix(_) | path::Component::RootDir | path::Component::CurDir => {
                    None
                }
                other => Some(other),
            })
            .collect::<PathBuf>()
            .display()
            .to_string()
    }
}

impl From<PathBuf> for TypstFilePath {
    fn from(path: PathBuf) -> Self {
        Self(path)
    }
}

impl From<TypstFilePath> for PathBuf {
    fn from(path: TypstFilePath) -> Self {
        path.0
    }
}

impl fmt::Display for TypstFilePath {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        self.display_route_segments(f)
    }
}

impl ToRouteSegments for TypstFilePath {
    fn display_route_segments(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        self.0
            .components()
            .map(|c| c.as_os_str().to_string_lossy())
            .filter(|v| !v.is_empty())
            .try_for_each(|part| write!(f, "/{part}"))
    }
}

impl FromRouteSegments for TypstFilePath {
    type Err = std::convert::Infallible;

    fn from_route_segments(segments: &[&str]) -> Result<Self, Self::Err> {
        Ok(Self(segments.iter().collect()))
    }
}

#[derive(Serialize, Deserialize, Clone, Debug)]
pub enum ServerEvent {
    FileUpdate(ServerFnResult<String>),
    FileFocused(TypstFilePath),
}

#[derive(Serialize, Deserialize, Clone, Debug)]
pub enum ClientEvent {
    FileMoved(TypstFilePath),
}
