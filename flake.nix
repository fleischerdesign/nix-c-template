{
  description = "A reproducible C development environment with modern tooling.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    let
      # Granular builder helper for consumer flakes (Way A)
      mkCShell =
        {
          pkgs,
          extraPackages ? [ ],
          env ? { },
          shellHook ? "",
        }:
        let
          baseShell = pkgs.mkShell {
            packages =
              [
                pkgs.clang
                pkgs.gdb
                pkgs.gnumake
                pkgs.cmake
                pkgs.pkg-config
                pkgs.clang-tools
                pkgs.bear
                pkgs.valgrind
              ]
              ++ extraPackages;
            shellHook = ''
              echo "Entering C development environment..."
              echo "Tools: clang, gdb, make, cmake, bear, valgrind"
              echo "Run 'make', 'make debug', or 'nix build'"
            '';
          };
        in
        baseShell.overrideAttrs (oldAttrs: {
          env = oldAttrs.env or { } // env;
          shellHook = (oldAttrs.shellHook or "") + "\n" + shellHook;
        });
    in
    {
      # Granular Library helper functions for consumer flakes
      lib = {
        inherit mkCShell;
      };

      # Scaffolding templates for 'nix flake init' (Way B)
      templates = {
        default = {
          path = ./.;
          description = "A reproducible C development environment with modern tooling";
        };
      };
    }
    // flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        defaultShell = mkCShell { inherit pkgs; };
      in
      {
        packages.default = pkgs.stdenv.mkDerivation {
          name = "app";
          src = self;
          nativeBuildInputs = [ pkgs.gnumake ];
          buildPhase = "make";
          installPhase = "mkdir -p $out/bin && cp build/release/app $out/bin/";
        };

        devShells = {
          default = defaultShell;
        };

        checks = {
          default = defaultShell;
        };

        apps = {
          default = flake-utils.lib.mkApp {
            drv = pkgs.writeShellScriptBin "c-env-info" ''
              echo "=== C Nix Development Environment ==="
              ${pkgs.clang}/bin/clang --version
            '';
          };
        };

        formatter = pkgs.nixfmt-rfc-style;
      }
    );
}
