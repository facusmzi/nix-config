{
  description = "Entorno de desarrollo Avalonia con .NET 8";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        
        # Script helper para crear proyectos Avalonia
        avaloniaNew = pkgs.writeShellScriptBin "avalonia-new" ''
          if [ -z "$1" ]; then
            echo "Uso: avalonia-new <nombre-proyecto>"
            echo ""
            echo "Templates disponibles:"
            echo "  app           - Avalonia Application"
            echo "  mvvm          - Avalonia MVVM Application"
            echo "  xplat         - Avalonia Cross Platform Application"
            echo ""
            echo "Ejemplo: avalonia-new MiApp"
            exit 1
          fi
          
          PROJECT_NAME=$1
          TEMPLATE=''${2:-mvvm}
          
          echo "🎨 Creando proyecto Avalonia: $PROJECT_NAME"
          dotnet new install Avalonia.Templates
          dotnet new avalonia.$TEMPLATE -n $PROJECT_NAME
          cd $PROJECT_NAME
          dotnet restore
          echo ""
          echo "✅ Proyecto creado en: ./$PROJECT_NAME"
          echo "Para ejecutar: cd $PROJECT_NAME && dotnet run"
        '';
        
        # Script para ejecutar con hot reload
        avaloniaRun = pkgs.writeShellScriptBin "avalonia-run" ''
          echo "🚀 Iniciando Avalonia con hot reload..."
          dotnet watch run
        '';
        
        # Script para preview de diseñador
        avaloniaPreview = pkgs.writeShellScriptBin "avalonia-preview" ''
          echo "👁️  Iniciando Avalonia Previewer..."
          echo "Abre tu IDE y usa el previewer integrado"
          echo "O visita: http://localhost:8080"
          dotnet tool run avalonia-preview
        '';
        
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            # .NET 8 SDK
            dotnet-sdk_8
            
            # Omnisharp para LSP (Emacs, VSCode, etc)
            omnisharp-roslyn
            
            # Herramientas de .NET
            dotnetPackages.Nuget
            
            # Dependencias de sistema para Avalonia (Linux)
            fontconfig
            libglvnd
            xorg.libX11
            xorg.libXcursor
            xorg.libXi
	    xorg.libICE      # ← AGREGAR
 	    xorg.libSM       # ← AGREGAR
            xorg.libXrandr
            libGL
            
            # Wayland support
            wayland
            
            # Para desarrollo
            git
            
            # Scripts helper
            avaloniaNew
            avaloniaRun
            avaloniaPreview
          ];

          shellHook = ''
            echo "╔════════════════════════════════════════╗"
            echo "║   Avalonia UI .NET 8 DevShell         ║"
            echo "╚════════════════════════════════════════╝"
            echo ""
            echo "🔧 Herramientas instaladas:"
            echo "   .NET SDK: $(dotnet --version)"
            echo "   Avalonia Templates: Instalados"
            echo ""
            echo "📦 Comandos disponibles:"
            echo "   avalonia-new <nombre>    - Crear nuevo proyecto Avalonia"
            echo "   avalonia-run             - Ejecutar con hot reload"
            echo "   avalonia-preview         - Iniciar previewer"
            echo ""
            echo "🎨 Crear proyecto:"
            echo "   avalonia-new MiApp       - MVVM Application"
            echo "   avalonia-new MiApp app   - Basic Application"
            echo "   avalonia-new MiApp xplat - Cross Platform"
            echo ""
            echo "🚀 Workflow típico:"
            echo "   1. avalonia-new MiApp"
            echo "   2. cd MiApp"
            echo "   3. dotnet run (o avalonia-run para hot reload)"
            echo ""
            
            # Instalar Avalonia templates si no están
            if ! dotnet new list | grep -q avalonia; then
              echo "📥 Instalando templates de Avalonia..."
              dotnet new install Avalonia.Templates > /dev/null 2>&1
              echo "✅ Templates instalados"
              echo ""
            fi
            
            # Configurar variables para mejor soporte gráfico
            export DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=0
            export AVALONIA_GLOBAL_SCALE_FACTOR=1
            
            # Para Wayland
            if [ -n "$WAYLAND_DISPLAY" ]; then
              export AVALONIA_USE_WAYLAND=1
              echo "🪟 Wayland detectado - usando backend nativo"
              echo ""
            fi
          '';

          # Variables de entorno
          DOTNET_ROOT = "${pkgs.dotnet-sdk_8}";
          DOTNET_CLI_TELEMETRY_OPTOUT = "1";
          DOTNET_SKIP_FIRST_TIME_EXPERIENCE = "1";
          
          # Para que funcione correctamente en NixOS
          LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [
            pkgs.fontconfig
            pkgs.libglvnd
            pkgs.xorg.libX11
            pkgs.xorg.libXcursor
            pkgs.xorg.libXi
	    pkgs.xorg.libICE      # ← AGREGAR
 	    pkgs.xorg.libSM       # ← AGREGAR
            pkgs.xorg.libXrandr
            pkgs.libGL
            pkgs.wayland
          ];
        };
      }
    );
}
