{ config, pkgs, lib, inputs, ... }:
let
  users = [ "facusmzi" ];
in
{
  fonts.packages = with pkgs; [
#     iosevka-comfy.comfy
#     nerd-fonts.fira-code
#     roboto
  ];

  environment.systemPackages = with pkgs; [
#     ripgrep
  ];

  home-manager.users = lib.genAttrs users (username: {
    programs.emacs = {
      enable = true;
      package = pkgs.emacs30-pgtk;
      extraPackages = epkgs: with epkgs; [
        # UI
        dracula-theme

        vertico
        orderless
        marginalia
        consult
        rainbow-delimiters

        # keybinds
        evil
        evil-collection
        general

        #terminal
        vterm

        #programacion
        magit
        corfu
        cape
        envrc
        # lsp
        lsp-mode
        lsp-ui
        yasnippet
        web-mode
        json-mode
        typescript-mode
        js2-mode


      ];
    };

    home.file.".config/emacs" = {
      source = ./emacs.d;
      recursive = true;
    };
  });
}
