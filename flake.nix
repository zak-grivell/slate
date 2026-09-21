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
        slate = pkgs.rustPlatform.buildRustPackage {
          pname = "slate";
          version = "0.1.0";

          src = ./.;
          cargoLock = {
            lockFile = ./Cargo.lock;
          };

          nativeBuildInputs =
            [
              pkgs.makeWrapper
              pkgs.binaryen
              pkgs.dioxus-cli
              pkgs.lld
              wasm-bindgen-cli-02121
            ]
            ++ pkgs.lib.optionals pkgs.stdenv.isDarwin [pkgs.darwin.sigtool];

          cargoBuildFlags = [
            "-p"
            "slate-cli"
          ];

          postBuild = ''
            dx bundle \
              --package slate-app \
              --fullstack \
              --release \
              --codesign false \
              --force-sequential true \
              --out-dir target/slate-bundle \
              --cargo-args="--offline"
          '';

          postInstall = ''
            cp -R target/slate-bundle/public "$out/bin/public"
            cp client/assets/tailwind.css "$out/bin/public/assets/tailwind.css"
          '';

          postFixup = ''
            for bin in "$out"/bin/*; do
              if [ -f "$bin" ] && [ -x "$bin" ]; then
                wrapProgram "$bin" --prefix PATH : ${pkgs.lib.makeBinPath [pkgs.tinymist]}
              fi
            done
          '';

          meta = with pkgs.lib; {
            description = "A Typst-native notes application";
            mainProgram = "slate-cli";
            platforms = platforms.unix;
          };
        };
      in {
        packages = {
          default = slate;
          inherit slate;
        };

        apps = {
          default = {
            type = "app";
            program = "${slate}/bin/slate-cli";
          };
          slate = {
            type = "app";
            program = "${slate}/bin/slate-cli";
          };
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
