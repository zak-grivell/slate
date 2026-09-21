use clap::{Parser, Subcommand};
use slate_client::App;
use std::{
    net::SocketAddr,
    path::{Path, PathBuf},
    process::Stdio,
    time::Duration,
};
use tokio::{
    net::{TcpListener, TcpStream},
    process::{Child, Command},
    time::sleep,
};

mod lsp;

#[derive(Parser)]
#[command(name = "slate")]
struct Cli {
    #[command(subcommand)]
    command: Commands,
}

#[derive(Subcommand)]
enum Commands {
    /// Serve a live web preview for a Typst file or vault.
    Preview {
        #[arg(default_value = ".")]
        path: PathBuf,
        /// Port to listen on. Use 0 to let the OS choose an available port.
        #[arg(long, default_value_t = 0)]
        port: u16,
        #[arg(long)]
        no_open: bool,
        #[arg(long, hide = true)]
        parent_pid: Option<u32>,
    },
    /// Run an LSP proxy around Tinymist with Slate link navigation.
    Lsp {
        /// Preview port. Use 0 to let the OS choose an available port.
        #[arg(long, default_value_t = 0)]
        port: u16,
        #[arg(long)]
        no_open: bool,
    },
    Export,
}

#[tokio::main]
async fn main() {
    let cli = Cli::parse();

    match cli.command {
        Commands::Preview {
            path,
            port,
            no_open,
            parent_pid,
        } => run_preview(path, port, !no_open, parent_pid).await,
        Commands::Lsp { port, no_open } => {
            if let Err(err) = lsp::run(port, !no_open).await {
                eprintln!("slate lsp: {err}");
                std::process::exit(1);
            }
        }
        Commands::Export => {
            todo!() // this should put all in docs folder
        }
    }
}

async fn run_preview(path: PathBuf, port: u16, open: bool, parent_pid: Option<u32>) {
    let (root, initial_file) = preview_paths(&path);
    if let Err(err) = std::env::set_current_dir(&root) {
        eprintln!("slate preview: could not enter {}: {err}", root.display());
        std::process::exit(1);
    }

    let address = SocketAddr::from(([127, 0, 0, 1], port));
    let listener = match TcpListener::bind(address).await {
        Ok(listener) => listener,
        Err(err) => {
            eprintln!("slate preview: could not listen on {address}: {err}");
            std::process::exit(1);
        }
    };
    let port = listener
        .local_addr()
        .expect("bound preview listener should have a local address")
        .port();
    let url = preview_url(port, &initial_file);
    eprintln!("Slate preview: {url}");

    if open {
        let url = url.clone();
        tokio::spawn(async move {
            wait_until_listening(port).await;
            if let Err(err) = open_browser(&url) {
                eprintln!("slate preview: could not open browser: {err}");
            }
        });
    }

    let router = dioxus::server::router(App);
    let server = axum::serve(listener, router);
    if let Some(parent_pid) = parent_pid {
        tokio::select! {
            result = server => {
                if let Err(err) = result {
                    eprintln!("slate preview server stopped: {err}");
                    std::process::exit(1);
                }
            }
            _ = wait_for_parent_exit(parent_pid) => {}
        }
    } else if let Err(err) = server.await {
        eprintln!("slate preview server stopped: {err}");
        std::process::exit(1);
    }
}

#[cfg(unix)]
async fn wait_for_parent_exit(parent_pid: u32) {
    loop {
        // Signal 0 only checks whether the process exists; it does not send a signal.
        let alive = unsafe { libc::kill(parent_pid as libc::pid_t, 0) == 0 };
        if !alive {
            return;
        }
        sleep(Duration::from_millis(500)).await;
    }
}

#[cfg(not(unix))]
async fn wait_for_parent_exit(_parent_pid: u32) {
    std::future::pending::<()>().await;
}

fn preview_paths(path: &Path) -> (PathBuf, PathBuf) {
    if path.is_dir() {
        (path.to_path_buf(), PathBuf::from("vault.typ"))
    } else {
        (
            path.parent()
                .unwrap_or_else(|| Path::new("."))
                .to_path_buf(),
            path.file_name()
                .map(PathBuf::from)
                .unwrap_or_else(|| PathBuf::from("vault.typ")),
        )
    }
}

fn preview_url(port: u16, path: &Path) -> String {
    let route = path
        .components()
        .filter_map(|part| {
            let part = part.as_os_str().to_str()?;
            (!part.is_empty() && part != ".").then_some(part)
        })
        .map(|part| url::form_urlencoded::byte_serialize(part.as_bytes()).collect::<String>())
        .collect::<Vec<_>>()
        .join("/");
    format!("http://127.0.0.1:{port}/file/{route}")
}

async fn wait_until_listening(port: u16) {
    for _ in 0..50 {
        if TcpStream::connect(("127.0.0.1", port)).await.is_ok() {
            return;
        }
        sleep(Duration::from_millis(100)).await;
    }
}

fn open_browser(url: &str) -> std::io::Result<()> {
    #[cfg(target_os = "macos")]
    let mut command = std::process::Command::new("open");
    #[cfg(target_os = "linux")]
    let mut command = std::process::Command::new("xdg-open");
    #[cfg(target_os = "windows")]
    let mut command = {
        let mut command = std::process::Command::new("cmd");
        command.args(["/C", "start", ""]);
        command
    };

    command
        .arg(url)
        .stdout(Stdio::null())
        .stderr(Stdio::null())
        .spawn()?;
    Ok(())
}

pub(crate) fn spawn_preview(root: &Path, port: u16, open: bool) -> std::io::Result<Child> {
    let executable = std::env::current_exe()?;
    let mut command = Command::new(executable);
    command
        .arg("preview")
        .arg(root)
        .arg("--port")
        .arg(port.to_string())
        .arg("--parent-pid")
        .arg(std::process::id().to_string());
    if !open {
        command.arg("--no-open");
    }
    command
        .current_dir(root)
        .stdin(Stdio::null())
        .stdout(Stdio::null())
        .stderr(Stdio::inherit())
        .kill_on_drop(true)
        .spawn()
}
