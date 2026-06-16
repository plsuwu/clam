{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs =
    { self, nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      buildRaylib =
        let
          clamdir = "/home/please/src/clam";
          emFlags = "-Os -Wall -DPLATFORM_WEB";
        in
        pkgs.writeShellScriptBin "build-raylib" ''
          #!/usr/bin/env bash

          cd ${clamdir}/raylib/src/

          ${pkgs.emscripten}/bin/emcc -c rcore.c ${emFlags} -DGRAPHICS_API_OPENGL_ES2
          ${pkgs.emscripten}/bin/emcc -c rshapes.c ${emFlags} -DGRAPHICS_API_OPENGL_ES2
          ${pkgs.emscripten}/bin/emcc -c rtextures.c ${emFlags} -DGRAPHICS_API_OPENGL_ES2
          ${pkgs.emscripten}/bin/emcc -c rtext.c ${emFlags} -DGRAPHICS_API_OPENGL_ES2
          ${pkgs.emscripten}/bin/emcc -c rmodels.c ${emFlags} -DGRAPHICS_API_OPENGL_ES2
          ${pkgs.emscripten}/bin/emcc -c raudio.c ${emFlags}

          ${pkgs.emscripten}/bin/emar rcs libraylib.a \
              rcore.o      \
              rshapes.o    \
              rtextures.o  \
              rtext.o      \
              rmodels.o    \
              raudio.o
        '';
    in
    {
      devShells.x86_64-linux.default =
        pkgs.mkShell.override
          {
            stdenv = pkgs.llvmPackages_latest.stdenv;
          }
          {
            buildInputs = [
              pkgs.emscripten
              pkgs.bear
              pkgs.nodejs

              buildRaylib
            ];
          };
    };
}
