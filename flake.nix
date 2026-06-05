{
  description = "Rust development shell and package";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {
          inherit system;
        };
        wasm-bindgen-cli-02121 = pkgs.rustPlatform.buildRustPackage rec {
          pname = "wasm-bindgen-cli";
          version = "0.2.121";

          src = pkgs.fetchCrate {
            inherit pname version;
            hash = "sha256-ZOMgFNOcGkO66Jz/Z83eoIu+DIzo3Z/vq6Z5g6BDY/w=";
          };

          cargoHash = "sha256-DPdCDPTAPBrbqLUqnCwQu1dePs9lGg85JCJOCIr9qjU=";
        };
      in {
        packages.default = pkgs.rustPlatform.buildRustPackage {
          pname = "rust-app";
          version = "0.1.0";

          src = ./.;
          cargoLock = {
            lockFile = ./Cargo.lock;
          };

          nativeBuildInputs = [pkgs.makeWrapper];

          postFixup = ''
            for bin in "$out"/bin/*; do
              wrapProgram "$bin" --prefix PATH : ${pkgs.lib.makeBinPath [pkgs.tinymist]}
            done
          '';
        };

        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            rustc
            cargo
            rustfmt
            clippy
            rust-analyzer
            tailwindcss_4
            wasm-bindgen-cli-02121
            lld
            dioxus-cli

            tinymist
            typst

            vscode-langservers-extracted
            typescript-language-server
          ];
        };
      }
    );
}
