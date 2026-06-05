use dioxus::prelude::*;
use dioxus_router::{FromRouteSegments, ToRouteSegments};
use serde::{Deserialize, Serialize};
use std::path::PathBuf;

#[derive(Debug, Serialize, Deserialize, Clone, PartialEq, Eq)]
pub struct TypstFileMetaData {
    pub tags: Vec<String>,
    pub links: Vec<String>,
    pub path: PathBuf,
}
use std::{fmt, path::Path};

#[derive(Clone, Debug, PartialEq, Eq, Serialize, Deserialize)]
pub struct RoutePath(pub PathBuf);

impl RoutePath {
    pub fn as_path(&self) -> &Path {
        &self.0
    }

    pub fn into_path_buf(self) -> PathBuf {
        self.0
    }
}

impl From<PathBuf> for RoutePath {
    fn from(path: PathBuf) -> Self {
        Self(path)
    }
}

impl From<RoutePath> for PathBuf {
    fn from(path: RoutePath) -> Self {
        path.0
    }
}

impl fmt::Display for RoutePath {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        self.display_route_segments(f)
    }
}

impl ToRouteSegments for RoutePath {
    fn display_route_segments(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        for component in self.0.components() {
            let part = component.as_os_str().to_string_lossy();

            if part.is_empty() {
                continue;
            }

            write!(f, "/{part}")?;
        }

        Ok(())
    }
}

impl FromRouteSegments for RoutePath {
    type Err = std::convert::Infallible;

    fn from_route_segments(segments: &[&str]) -> Result<Self, Self::Err> {
        Ok(Self(segments.iter().collect()))
    }
}

#[derive(Serialize, Deserialize, Clone, Debug)]
pub enum ServerEvent {
    FileUpdate(ServerFnResult<String>),
}

#[derive(Serialize, Deserialize, Clone, Debug)]
pub enum ClientEvent {
    FileMoved(RoutePath),
}
