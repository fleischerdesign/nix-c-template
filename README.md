# C Project Template

A reproducible C development environment with Nix flakes, direnv, and Make.

## Quick Start

```sh
# Enter the development shell
direnv allow

# Build
make

# Build debug (sanitizers enabled)
make debug

# Run
./build/release/app

# Generate compile_commands.json for LSP
make compile_commands.json
```

## Nix

```sh
# Build via Nix
nix build

# Enter dev shell manually
nix develop
```

## Tooling

- **clangd**: LSP support via `compile_commands.json` (run `make compile_commands.json`)
- **clang-format**: `nix fmt` or `clang-format -i src/*.c`
- **debug**: `make debug` enables AddressSanitizer and UndefinedBehaviorSanitizer
- **valgrind**: Available in dev shell — `valgrind ./build/release/app`
