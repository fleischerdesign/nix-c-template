{
  description = "A reproducible C development environment with modern tooling.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          packages = [
            pkgs.clang
            pkgs.gdb
            pkgs.make
            pkgs.cmake
            pkgs.pkg-config
            pkgs.clang-tools
          ];
          shellHook = ''
            echo "Entering C development environment..."
            echo "Available tools: clang, gdb, make, cmake"
          '';
        };
      });
}