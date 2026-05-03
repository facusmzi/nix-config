{ config, pkgs, lib, ... }:

let
  users = [ "facusmzi" ];

  flameshot-gui = pkgs.writeShellScriptBin "flameshot-gui" ''
    QT_QPA_PLATFORM=wayland ${pkgs.flameshot}/bin/flameshot gui
  '';
in
{
  # ─── Sistema ───────────────────────────────────────────────
  services.xserver.enable = true;
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    epiphany
    geary
  ];

  environment.systemPackages = with pkgs; [
    gnome-tweaks
    gnomeExtensions.appindicator
    gnomeExtensions.tray-icons-reloaded
    gnomeExtensions.removable-drive-menu
    gnomeExtensions.blur-my-shell
    gnomeExtensions.dash-to-dock
    gnomeExtensions.clipboard-indicator
    gnomeExtensions.pop-shell
    gnomeExtensions.transparent-window-moving
    gnomeExtensions.caffeine
    gnomeExtensions.user-themes
    flameshot-gui
    flameshot
    qt5.qtwayland
  ];

  # ─── Home Manager ──────────────────────────────────────────
  home-manager.users = lib.genAttrs users (_: {
    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        accent-color = "purple";
      };

      "org/gnome/settings-daemon/plugins/media-keys" = {
        custom-keybindings = [
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/flameshot/"
        ];
      };

      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/flameshot" = {
        name = "Flameshot";
        command = "${flameshot-gui}/bin/flameshot-gui";
        binding = "<Control>ntilde";
      };
    };

    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "text/plain"       = "org.gnome.TextEditor.desktop";
        "text/x-nix"       = "org.gnome.TextEditor.desktop";
        "text/x-python"    = "org.gnome.TextEditor.desktop";
        "text/x-shellscript" = "org.gnome.TextEditor.desktop";
        "text/markdown"    = "org.gnome.TextEditor.desktop";
        "application/json" = "org.gnome.TextEditor.desktop";
        "application/xml"  = "org.gnome.TextEditor.desktop";
      };
    };
  });
}
