
{
  description = "Nix shell to run an Uqbar node";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs = { self, nixpkgs, rust-overlay, ... }:
      let
        system = "x86_64-linux";
        pkgs = import nixpkgs {
          inherit system;
          overlays = [rust-overlay.overlays.default];
        };
        toolchain = pkgs.rust-bin.fromRustupToolchainFile ./toolchain.toml;

      in  {
        devShells.${system}.default = pkgs.mkShell {
          packages = [
            toolchain
            pkgs.clang
            pkgs.llvmPackages.libclang
            pkgs.openssl
            pkgs.fish
            pkgs.pkg-config
          ];
          shellHook = ''
            export LIBCLANG_PATH="${pkgs.llvmPackages.libclang.lib}/lib";
            exec fish
            source $HOME/.config/fish/config.fish
            echo "Welcome to your Rust development environment!"
          '';

        };
      };
}
