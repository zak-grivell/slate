use clap::{Parser, Subcommand};
use std::path::PathBuf;

#[derive(Parser)]
#[command(name = "program")]
struct Cli {
    #[command(subcommand)]
    command: Commands,
}

#[derive(Subcommand)]
enum Commands {
    Preview {
        #[arg(short, long)]
        path: PathBuf,
    },
    Export,
}

#[tokio::main]
async fn main() {
    let cli = Cli::parse();

    match cli.command {
        Commands::Preview { path } => {
            println!("Previewing at: http://localhost:3000/{}", path.display());

            // slate_server::start_server().await;
        }
        Commands::Export => {
            todo!() // this should put all in docs folder
        }
    }
}
