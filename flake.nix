{
  description = "Build a cargo project with a custom toolchain";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    crane.url = "github:ipetkov/crane";
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      crane,
      flake-utils,
      rust-overlay,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ (import rust-overlay) ];
        };

        craneLib = (crane.mkLib pkgs).overrideToolchain (
          p:
          p.rust-bin.stable.latest.default.override {
            targets = [ "wasm32-unknown-unknown" ];
          }
        );

      in
      {
        devShells.default = craneLib.devShell {
          LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath (
            with pkgs;
            [
              vulkan-loader
              libx11
              libx11
              libxi
              libxkbcommon
              wayland
            ]
          );

          packages = with pkgs; [
            pkg-config
            wasm-pack
            alsa-lib

            vulkan-loader
            vulkan-tools

            libx11
            libx11
            libxi
            libxkbcommon
            wayland

            libudev-zero
          ];
        };
      }
    );
}
