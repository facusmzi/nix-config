{ config, pkgs, lib, ... }:

# Módulo home-manager compartido para KDE Plasma 6.
# Importar desde home/<usuario>/default.nix:
#
#   imports = [ ../../modules/home/plasma.nix ];

{
  programs.home-manager.enable = true;

  programs.plasma = {
    enable = true;

    workspace = {
      lookAndFeel = "org.kde.breezedark.desktop";
    };

    spectacle.shortcuts = {
      captureEntireDesktop  = "";
      captureRectangularRegion = "Ctrl+Ñ";
      launch                = "";
      recordRegion          = "";
      recordScreen          = "";
      recordWindow          = "";
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

  xdg.mimeApps.defaultApplications = {
    "text/plain"             = [ "org.kde.kate.desktop" ];
    "inode/directory"        = [ "org.kde.dolphin.desktop" ];
    "application/octet-stream" = [ "org.kde.kate.desktop" ];
  };
}
