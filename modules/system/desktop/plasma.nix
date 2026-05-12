{ config, pkgs, lib, ... }:

let
  # Usuarios que van a tener la config de plasma en home-manager
  users = [ "facusmzi" ];
in
{
  # FIX para variables de entorno excesivamente largas en plasma-workspace
  # https://github.com/NixOS/nixpkgs/issues/126590#issuecomment-3194531220
  nixpkgs.overlays = lib.singleton (final: prev: {
    kdePackages = prev.kdePackages // {
      plasma-workspace =
        let
          basePkg = prev.kdePackages.plasma-workspace;

          xdgdataPkg = pkgs.stdenv.mkDerivation {
            name = "${basePkg.name}-xdgdata";
            buildInputs = [ basePkg ];
            dontUnpack = true;
            dontFixup = true;
            dontWrapQtApps = true;
            installPhase = ''
              mkdir -p $out/share
              ( IFS=:
                for DIR in $XDG_DATA_DIRS; do
                  if [[ -d "$DIR" ]]; then
                    cp -r $DIR/. $out/share/
                    chmod -R u+w $out/share
                  fi
                done
                )
            '';
          };

          derivedPkg = basePkg.overrideAttrs {
            preFixup = ''
              for index in "''${!qtWrapperArgs[@]}"; do
                if [[ ''${qtWrapperArgs[$((index+0))]} == "--prefix" ]] && [[ ''${qtWrapperArgs[$((index+1))]} == "XDG_DATA_DIRS" ]]; then
                  unset -v "qtWrapperArgs[$((index+0))]"
                  unset -v "qtWrapperArgs[$((index+1))]"
                  unset -v "qtWrapperArgs[$((index+2))]"
                  unset -v "qtWrapperArgs[$((index+3))]"
                fi
              done
              qtWrapperArgs=("''${qtWrapperArgs[@]}")
              qtWrapperArgs+=(--prefix XDG_DATA_DIRS : "${xdgdataPkg}/share")
              qtWrapperArgs+=(--prefix XDG_DATA_DIRS : "$out/share")
            '';
          };
        in
          derivedPkg;
    };
  });

  # ─── Sistema ───────────────────────────────────────────────
  services.desktopManager.plasma6.enable = true;

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    theme = "breeze";
    settings.General.DisplayServer = "wayland";
  };

  services.displayManager.defaultSession = "plasma";

  environment.systemPackages = with pkgs; [
    kdePackages.konsole
    kdePackages.dolphin
    kdePackages.kate
    kdePackages.gwenview
    kdePackages.spectacle
    kdePackages.okular
  ];

  # ─── Home Manager ──────────────────────────────────────────
  home-manager.users = lib.genAttrs users (_: {
    programs.home-manager.enable = true;

    programs.plasma = {
      enable = true;

      workspace.lookAndFeel = "org.kde.breezedark.desktop";

      spectacle.shortcuts = {
        captureEntireDesktop     = "";
        captureRectangularRegion = "Ctrl+Ñ";
        launch                   = "";
        recordRegion             = "";
        recordScreen             = "";
        recordWindow             = "";
      };

      hotkeys.commands = {
        screenshot-fullscreen = {
          name    = "Captura pantalla completa";
          key     = "Meta+Ctrl+S";
          command = "spectacle --fullscreen --nonotify";
        };
      };


      panels = [
        {
          location = "bottom";
          widgets = [
            { name = "org.kde.plasma.kickoff"; }
            {
              name = "org.kde.plasma.icontasks";
              config.General.launchers = [
                "applications:org.kde.konsole.desktop"
                "applications:org.kde.dolphin.desktop"
                "applications:firefox.desktop"
              ];
            }
            "org.kde.plasma.marginsseparator"
            {
              name = "org.kde.plasma.systemtray";
              config.General.shown = [
                "org.kde.plasma.networkmanagement"
                "org.kde.plasma.volume"
              ];
            }
            {
              name = "org.kde.plasma.digitalclock";
              config.Appearance.use24hFormat = "2";
            }
            "org.kde.plasma.showdesktop"
          ];
        }
      ];
    };

    home.sessionVariables = {
      EDITOR = "kate --block";
      VISUAL = "kate --block";
    };

    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "text/plain"               = [ "org.kde.kate.desktop" ];
        "text/x-nix"               = [ "org.kde.kate.desktop" ];
        "text/x-python"            = [ "org.kde.kate.desktop" ];
        "text/x-shellscript"       = [ "org.kde.kate.desktop" ];
        "text/x-csrc"              = [ "org.kde.kate.desktop" ];
        "text/x-c++src"            = [ "org.kde.kate.desktop" ];
        "text/x-chdr"              = [ "org.kde.kate.desktop" ];
        "text/x-c++hdr"            = [ "org.kde.kate.desktop" ];
        "text/x-java"              = [ "org.kde.kate.desktop" ];
        "text/javascript"          = [ "org.kde.kate.desktop" ];
        "text/css"                 = [ "org.kde.kate.desktop" ];
        "text/xml"                 = [ "org.kde.kate.desktop" ];
        "text/markdown"            = [ "org.kde.kate.desktop" ];
        "text/x-rust"              = [ "org.kde.kate.desktop" ];
        "application/json"         = [ "org.kde.kate.desktop" ];
        "application/x-yaml"       = [ "org.kde.kate.desktop" ];
        "application/xml"          = [ "org.kde.kate.desktop" ];
        "application/toml"         = [ "org.kde.kate.desktop" ];
        "application/octet-stream" = [ "org.kde.kate.desktop" ];
        "inode/directory"          = [ "org.kde.dolphin.desktop" ];
        "application/pdf"          = [ "org.kde.okular.desktop" ];
      };
    };
  });
}
