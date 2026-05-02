{ config, pkgs, lib, ... }:

{
  programs.home-manager.enable = true;

  programs.plasma = {
    enable = true;

    workspace = {
      lookAndFeel = "org.kde.breezedark.desktop";
    };

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

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      # Editor de texto — Kate
      "text/plain"              = [ "org.kde.kate.desktop" ];
      "text/x-nix"              = [ "org.kde.kate.desktop" ];
      "text/x-python"           = [ "org.kde.kate.desktop" ];
      "text/x-shellscript"      = [ "org.kde.kate.desktop" ];
      "text/x-csrc"             = [ "org.kde.kate.desktop" ];
      "text/x-c++src"           = [ "org.kde.kate.desktop" ];
      "text/x-chdr"             = [ "org.kde.kate.desktop" ];
      "text/x-c++hdr"           = [ "org.kde.kate.desktop" ];
      "text/x-java"             = [ "org.kde.kate.desktop" ];
      "text/javascript"         = [ "org.kde.kate.desktop" ];
      "text/css"                = [ "org.kde.kate.desktop" ];
      "text/xml"                = [ "org.kde.kate.desktop" ];
      "text/markdown"           = [ "org.kde.kate.desktop" ];
      "text/x-rust"             = [ "org.kde.kate.desktop" ];
      "application/json"        = [ "org.kde.kate.desktop" ];
      "application/x-yaml"      = [ "org.kde.kate.desktop" ];
      "application/xml"         = [ "org.kde.kate.desktop" ];
      "application/toml"        = [ "org.kde.kate.desktop" ];
      "application/octet-stream" = [ "org.kde.kate.desktop" ];

      # Gestor de archivos — Dolphin
      "inode/directory"         = [ "org.kde.dolphin.desktop" ];

      # PDFs — Okular
      "application/pdf"         = [ "org.kde.okular.desktop" ];
    };
  };
}
