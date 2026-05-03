{ pkgs, lib, ... }:

let
  users = [ "facusmzi" ];
in
{
  # ─── Sistema ───────────────────────────────────────────────
  environment.systemPackages = with pkgs; [
    firefox
  ];

  # ─── Home Manager ──────────────────────────────────────────
  home-manager.users = lib.genAttrs users (_: {
    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "text/html"                = [ "firefox.desktop" ];
        "x-scheme-handler/http"    = [ "firefox.desktop" ];
        "x-scheme-handler/https"   = [ "firefox.desktop" ];
        "x-scheme-handler/about"   = [ "firefox.desktop" ];
        "x-scheme-handler/unknown" = [ "firefox.desktop" ];
      };
    };
  });
}
