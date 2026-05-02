{
  description = "Entorno de desarrollo Rust";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        # Script helper para crear proyectos Rust
        cargoNew = pkgs.writeShellScriptBin "cargo-new" ''
          if [ -z "$1" ]; then
            echo "Uso: cargo-new <nombre-proyecto> [--lib]"
            echo ""
            echo "Ejemplos:"
            echo "  cargo-new mi-app         - Crea una aplicación"
            echo "  cargo-new mi-lib --lib   - Crea una biblioteca"
            exit 1
          fi

          PROJECT_NAME=$1
          shift

          echo "🦀 Creando proyecto Rust: $PROJECT_NAME"
          cargo new "$PROJECT_NAME" "$@"
          cd "$PROJECT_NAME"
          echo ""
          echo "✅ Proyecto creado en: ./$PROJECT_NAME"
          echo "Para ejecutar: cd $PROJECT_NAME && cargo run"
        '';

        # Script para ejecutar con watch
        cargoWatch = pkgs.writeShellScriptBin "cargo-watch" ''
          echo "👁️  Ejecutando con cargo-watch..."
          ${pkgs.cargo-watch}/bin/cargo-watch -x run
        '';

      in
      {
        devShells.default = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            # Toolchain de Rust
            cargo
            rustc
            rustfmt
            clippy
            rust-analyzer

            # Herramientas útiles
            cargo-watch
            cargo-edit
            cargo-expand

            # Para bindgen (si lo necesitas)
            rustPlatform.bindgenHook
            pkg-config

            # Scripts helper
            cargoNew
            cargoWatch
          ];

          buildInputs = with pkgs; [
            # Librerías comunes (descomenta las que necesites)
            # openssl
            # sqlite
            # postgresql
          ];

          shellHook = ''
            echo "╔════════════════════════════════════════╗"
            echo "║      Rust Development Shell           ║"
            echo "╚════════════════════════════════════════╝"
            echo ""
            echo "🔧 Herramientas instaladas:"
            echo "   Rust: $(rustc --version)"
            echo "   Cargo: $(cargo --version)"
            echo ""
            echo "📦 Comandos disponibles:"
            echo "   cargo-new <nombre>       - Crear nuevo proyecto"
            echo "   cargo build              - Compilar proyecto"
            echo "   cargo run                - Ejecutar proyecto"
            echo "   cargo test               - Ejecutar tests"
            echo "   cargo-watch              - Auto-recompilar al guardar"
            echo "   cargo clippy             - Linter"
            echo "   cargo fmt                - Formatear código"
            echo ""
            echo "🚀 Workflow típico:"
            echo "   1. cargo-new mi-app"
            echo "   2. cd mi-app"
            echo "   3. cargo run"
            echo ""
            echo "📝 Tips:"
            echo "   - cargo add <crate>      - Agregar dependencia"
            echo "   - cargo expand           - Ver macros expandidas"
            echo "   - cargo clippy --fix     - Aplicar sugerencias automáticamente"
            echo ""
          '';

          # Variables de entorno importantes
          RUST_SRC_PATH = "${pkgs.rustPlatform.rustLibSrc}";
          RUST_BACKTRACE = "1";

          # Para bindgen (descomenta si usas librerías C/C++)
          # PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
        };
      }
    );
}
