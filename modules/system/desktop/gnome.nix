{
  config,
  pkgs,
  lib,
  ...
}: let
  users = ["facusmzi"];
in {
  # ─── Sistema ───────────────────────────────────────────────

  services.xserver.enable = true;
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gnome
    ];
  };

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

    grim # ← necesario para Wayland

    qt5.qtwayland
    wl-clipboard
    # xclip ya no hace falta
  ];

  # ─── Home Manager ──────────────────────────────────────────

  home-manager.users = lib.genAttrs users (_: {
    services.flameshot = {
      enable = true;
      settings = {
        General = {
          useGrimAdapter = true;
          disabledGrimWarning = true;
          showStartupLaunchMessage = false;
          showDesktopNotification = true;
          showAbortNotification = false;
        };
      };
    };

    dconf.enable = true;

    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        accent-color = "purple";
      };

      "org/gnome/shell" = {
        enabled-extensions = with pkgs.gnomeExtensions; [
          appindicator.extensionUuid
          tray-icons-reloaded.extensionUuid
          "drive-menu@gnome-shell-extensions.gcampax.github.com"
          blur-my-shell.extensionUuid
          dash-to-dock.extensionUuid
          clipboard-indicator.extensionUuid
          pop-shell.extensionUuid
          caffeine.extensionUuid
          user-themes.extensionUuid
          transparent-window-moving.extensionUuid
        ];

        favorite-apps = [
          "firefox.desktop"
          "org.gnome.Console.desktop"
          "org.gnome.Nautilus.desktop"
        ];
      };

      "org/gnome/shell/extensions/dash-to-dock" = {
        show-trash = false;
        show-mounts = false;
        show-mounts-network = false;
      };

      "org/gnome/shell/extensions/clipboard-indicator" = {
        cache-images = true;
        notify-on-copy = false;
      };

      "org/gnome/settings-daemon/plugins/media-keys" = {
        custom-keybindings = [
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/flameshot/"
        ];
      };

      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/flameshot" = {
        name = "Flameshot";
        command = "flameshot gui"; # ← comando limpio, sin workaround
        binding = "<Control>ntilde";
      };
    };

    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "text/plain" = "org.gnome.TextEditor.desktop";
        "text/x-nix" = "org.gnome.TextEditor.desktop";
        "text/x-python" = "org.gnome.TextEditor.desktop";
        "text/x-shellscript" = "org.gnome.TextEditor.desktop";
        "text/markdown" = "org.gnome.TextEditor.desktop";
        "application/json" = "org.gnome.TextEditor.desktop";
        "application/xml" = "org.gnome.TextEditor.desktop";
      };
    };
  });
}
