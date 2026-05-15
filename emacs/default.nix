{ config, pkgs, lib, inputs, ... }:

let
  users = [ "facusmzi" ];
in
{
  fonts.packages = with pkgs; [
    iosevka-comfy.comfy
    nerd-fonts.terminess-ttf
    nerd-fonts.symbols-only
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    roboto
    symbola
    noto-fonts-color-emoji
  ];

  environment.systemPackages = with pkgs; [
    ripgrep
    libvterm
  ];

  home-manager.users = lib.genAttrs users (username: {
    programs.emacs = {
      enable = true;
      package = pkgs.emacs30-pgtk;
      extraPackages = epkgs: with epkgs; [
        ef-themes
        evil
        undo-tree
        hydra
        outshine

        # Librerías de utilidad — base para todo lo demás
        s      # string utilities: s-replace, s-concat, s-blank?, etc.
        dash   # list utilities: -map, -filter, --map, -first, etc.
        f      # file/path utilities: f-join, f-ext, f-relative, etc.

        projectile
        magit
        envrc

        vterm

        # editor
        corfu
        cape
        flycheck
        lsp-mode
        lsp-ui
        yasnippet


        # lang
        nix-mode
        rustic
        lsp-ui        # si no lo agregaste ya
        yasnippet     # ídem
        lsp-haskell
        haskell-mode

        #ui
        org-roam
        emacsql

        #media
        pdf-tools

      ];
    };

    home.file.".config/emacs".source = ./emacs.d;
  });
}
