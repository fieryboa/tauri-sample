{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/24.05";
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs = { self, nixpkgs, flake-utils, rust-overlay }:
    let 
      system = flake-utils.lib.system;
    in
      flake-utils.lib.eachSystem [
        system.x86_64-linux
        system.aarch64-linux
      ] (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [rust-overlay.overlays.default];
          };
          rust_toolchain = pkgs.rust-bin.fromRustupToolchainFile ./src-tauri/toolchain.toml;
        in {
          devShell = with pkgs; mkShell {
            packages = [
              nodejs_22
              rust_toolchain
              bun
              pkg-config
              openssl
              glib
              atk
              webkitgtk_4_1
              libsoup_3
            ];
          };
        }
      );
}
