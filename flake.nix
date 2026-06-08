{
  description = "A reproducible C development environment with modern tooling.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        packages.default = pkgs.stdenv.mkDerivation {
          name = "app";
          src = self;
          nativeBuildInputs = [ pkgs.gnumake ];
          buildPhase = "make";
          installPhase = "mkdir -p $out/bin && cp build/release/app $out/bin/";
        };

        devShells.default = pkgs.mkShell {
          packages = [
            pkgs.clang
            pkgs.gdb
            pkgs.gnumake
            pkgs.cmake
            pkgs.pkg-config
            pkgs.clang-tools
            pkgs.bear
            pkgs.valgrind
          ];
          shellHook = ''
            echo "Entering C development environment..."
            echo "Tools: clang, gdb, make, cmake, bear, valgrind"
            echo "Run 'make', 'make debug', or 'nix build'"
          '';
        };

        formatter = pkgs.clang-tools;
      });
}
