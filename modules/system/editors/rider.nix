{ pkgs, lib, ... }:

let
  dotnet-combined = (with pkgs.dotnetCorePackages; combinePackages [
    sdk_9_0
    sdk_8_0
    sdk_10_0
  ]).overrideAttrs (_: prev: {
    # Permite instalar workloads en $HOME en lugar del store de Nix
    # https://discourse.nixos.org/t/dotnet-maui-workload/20370/2
    postBuild = (prev.postBuild or "") + ''
      for i in $out/sdk/*; do
        i=$(basename $i)
        mkdir -p $out/metadata/workloads/''${i/-*}
        touch $out/metadata/workloads/''${i/-*}/userlocal
      done
    '';
  });

  rider-fhs = pkgs.buildFHSEnv {
    name = "rider";
    targetPkgs = pkgs: (with pkgs; [
      dotnet-combined
      dotnetCorePackages.aspnetcore_8_0
      dotnetCorePackages.aspnetcore_9_0
      dotnetCorePackages.aspnetcore_10_0
      powershell git
      icu openssl zlib krb5
    ]);
    runScript = "${pkgs.jetbrains.rider}/bin/rider";
    profile = ''
      export DOTNET_ROOT="${dotnet-combined}"
      export DOTNET_CLI_TELEMETRY_OPTOUT="1"
      export DOTNET_SKIP_FIRST_TIME_EXPERIENCE="1"
    '';
  };

  # .desktop como derivación → NixOS lo agrega a XDG_DATA_DIRS automáticamente
  rider-desktop = pkgs.writeTextFile {
    name        = "jetbrains-rider-fhs-desktop";
    destination = "/share/applications/jetbrains-rider.desktop";
    text = ''
      [Desktop Entry]
      Version=1.0
      Type=Application
      Name=JetBrains Rider
      Icon=${pkgs.jetbrains.rider}/share/pixmaps/rider.svg
      Exec=${rider-fhs}/bin/rider %f
      Comment=Cross-platform .NET IDE
      Categories=Development;IDE;
      Terminal=false
      StartupWMClass=jetbrains-rider
      StartupNotify=true
      MimeType=text/plain;text/x-csharp;application/x-sln;application/x-csproj;
    '';
  };
in
{
  # nix-ld para que los binarios precompilados encuentren las librerías
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc.lib
      fontconfig freetype icu openssl zlib krb5
      libglvnd libGL
      xorg.libX11 xorg.libXcursor xorg.libXi xorg.libICE xorg.libSM
      xorg.libXrandr xorg.libXrender xorg.libXext xorg.libXfixes
      wayland
      skia harfbuzz libwebp libjpeg libpng
      gst_all_1.gstreamer gst_all_1.gst-plugins-base gst_all_1.gst-plugins-good
    ];
  };

  environment.systemPackages = with pkgs; [
    dotnet-combined
    dotnet-ef
    omnisharp-roslyn
    dotnetPackages.Nuget
    powershell
    rider-fhs
    rider-desktop
  ];

  environment.sessionVariables = {
    DOTNET_ROOT                           = "${dotnet-combined}";
    DOTNET_CLI_TELEMETRY_OPTOUT           = "1";
    DOTNET_SKIP_FIRST_TIME_EXPERIENCE     = "1";
    DOTNET_TieredPGO                      = "1";
    DOTNET_TC_QuickJitForLoops            = "1";
    DOTNET_ReadyToRun                     = "1";
    DOTNET_gcServer                       = "1";
    DOTNET_GCConserveMemory               = "2";
    DOTNET_SYSTEM_GLOBALIZATION_INVARIANT = "0";
    AVALONIA_GLOBAL_SCALE_FACTOR          = "1";
    DOTNET_WATCH_SUPPRESS_LAUNCH_BROWSER  = "1";
    DOTNET_WATCH_RESTART_ON_RUDE_EDIT     = "1";

    # .NET carga nativas via P/Invoke (dlopen), no pasa por nix-ld,
    # así que LD_LIBRARY_PATH sigue siendo necesario para SkiaSharp y Avalonia
    LD_LIBRARY_PATH = lib.makeLibraryPath (with pkgs; [
      fontconfig libglvnd libGL wayland
      xorg.libX11 xorg.libXcursor xorg.libXi xorg.libICE xorg.libSM xorg.libXrandr
      skia harfbuzz libwebp libjpeg libpng zlib icu openssl krb5
      gst_all_1.gstreamer gst_all_1.gst-plugins-base
    ]);
  };

  environment.shellAliases = {
    dn           = "dotnet new";
    dr           = "dotnet run";
    db           = "dotnet build";
    dt           = "dotnet test";
    dw           = "dotnet watch run";
    dp           = "dotnet publish -c Release";
    dnapi        = "dotnet new webapi -n";
    dnweb        = "dotnet new web -n";
    dnblazor     = "dotnet new blazor -n";
    dnminimal    = "dotnet new webapi --use-minimal-apis -n";
    dnavui       = "dotnet new avalonia.mvvm -n";
    dnavapp      = "dotnet new avalonia.app -n";
    dnmaui       = "dotnet new maui -n";
    dna          = "dotnet add package";
    dnr          = "dotnet remove package";
    dnl          = "dotnet list package";
    dnoutdated   = "dotnet list package --outdated";
    dnvulnerable = "dotnet list package --vulnerable";
    dnclean      = "dotnet clean && rm -rf bin obj";
    dnrealclean  = "find . -iname 'bin' -o -iname 'obj' | xargs rm -rf";
    dncleancache = "dotnet nuget locals all --clear";
    dninfo       = "dotnet --info";
    dnsdk        = "dotnet --list-sdks";
    dnruntime    = "dotnet --list-runtimes";
  };

  # Instala templates de Avalonia la primera vez que el usuario inicia sesión.
  # Necesita correr como usuario porque dotnet escribe en $HOME.
  systemd.user.services.dotnet-avalonia-templates = {
    description = "Instalar templates de Avalonia para dotnet";
    wantedBy    = [ "default.target" ];
    serviceConfig = {
      Type            = "oneshot";
      RemainAfterExit = true;
      ExecStart = pkgs.writeShellScript "install-avalonia-templates" ''
        stamp="$HOME/.local/share/dotnet-avalonia-templates-installed"
        if [ ! -f "$stamp" ]; then
          echo "Instalando Avalonia templates..."
          ${dotnet-combined}/bin/dotnet new install Avalonia.Templates \
            && mkdir -p "$(dirname "$stamp")" \
            && touch "$stamp"
        fi
      '';
    };
  };
}
