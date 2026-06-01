{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
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
    alejandra
    nixd
  ];

  # ============================================================
  # HOME MANAGER
  # ============================================================

  home-manager.users = lib.genAttrs users (username: {
    programs.emacs = {
      enable = true;
      package = pkgs.emacs30-pgtk;
      extraPackages = epkgs:
        with epkgs; [
          # --- UI ---
          dracula-theme
          vertico
          orderless
          marginalia
          consult
          consult-dir

          # --- Modos de lenguaje ---
          nix-mode
          haskell-mode

          # --- LSP ---
          lsp-mode
          lsp-ui
          lsp-pyright
          # --- Autocompletado ---
          corfu
          cape

          # --- Git ---
          magit

          # --- Modal editing ---
          evil
          evil-collection
          undo-tree

          # --- Navegación / búsqueda ---
          wgrep
          restclient

          # --- Entorno ---
          envrc

          # --- Utilidades ---
          hydra
          helpful
          gptel
          vterm
        ];
    };

    home.file.".config/emacs" = {
      source = ./emacs.d;
      recursive = true;
    };
  });
}
