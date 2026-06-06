{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
let
  users = ["facusmzi"];
in {
  # ============================================================
  # FUENTES
  # ============================================================

  fonts.packages = with pkgs; [
    # iosevka-comfy.comfy
    # nerd-fonts.fira-code
    # roboto
  ];

  # ============================================================
  # PAQUETES DEL SISTEMA
  # ============================================================

  environment.systemPackages = with pkgs; [
    ripgrep
    texliveMedium
    texlivePackages.dvisvgm
  ];

  # ============================================================
  # HOME MANAGER
  # ============================================================

  home-manager.users = lib.genAttrs users (username: {
    programs.emacs = {
      enable = true;
      package = pkgs.emacs30-pgtk.override { withTreeSitter = true; };
      extraPackages = epkgs:
        with epkgs; [
          # --- UI ---
          dracula-theme

          # --- Entorno ---
          envrc
          nix-mode

          # --- Utilidades ---
          gptel
          preview-dvisvgm

          # --- Completion ---
          vertico
          orderless
          marginalia
          consult
          corfu
 

          # --- Treesitter grammars ---
          (treesit-grammars.with-grammars (g: [
            g.tree-sitter-python
            g.tree-sitter-nix
          ]))

          # --- vc ---
          magit


          # --- Evil ---
          evil
          evil-collection
          general
          
        ];
    };

    home.file.".config/emacs" = {
      source = ./emacs.d;
      recursive = true;
    };
  });
}
