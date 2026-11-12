{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
let
  users = [ "facusmzi" ];
in
{
  # ============================================================
  # FUENTES
  # ============================================================

  fonts.packages = with pkgs; [
    # iosevka-comfy.comfy
    nerd-fonts.fira-code
    # roboto
  ];

  # ============================================================
  # PAQUETES DEL SISTEMA
  # ============================================================

  environment.systemPackages = with pkgs; [
    ripgrep
    pandoc # para el preview de markdown-mode
    (texlive.combine {
      inherit (texlive)
        scheme-medium
        wrapfig
        ulem
        capt-of
        hyperref
        dvisvgm;
    })
    nixd
    nixfmt
  ];

  # ============================================================
  # HOME MANAGER
  # ============================================================

  home-manager.users = lib.genAttrs users (username: {
    programs.emacs = {
      enable = true;
      # Emacs 31 desde unstable (trae ob-csharp incluido). Tree-sitter ya
      # viene activado por defecto.
      package = pkgs.unstable.emacs-pgtk;
      extraPackages =
        epkgs: with epkgs; [
          # --- UI ---
          dracula-theme

          # --- Entorno ---
          envrc
          nix-mode
          markdown-mode

          # --- Utilidades ---
          preview-dvisvgm


          # --- Terminal ---
          vterm


          # --- Completion ---
          vertico
          orderless
          marginalia
          consult
          corfu
          consult-dir

          # --- vc ---
          magit

          # --- LSP ---
          lsp-mode
          lsp-ui

          # --- Haskell ---
          haskell-mode
          lsp-haskell


          # --- PDF ---
          pdf-tools

          # --- Edición ---
          move-text

          # --- Treesitter grammars ---
          (treesit-grammars.with-grammars (g: [
            g.tree-sitter-python
            g.tree-sitter-nix
          ]))

        ];
    };

    home.file.".config/emacs" = {
      source = ./emacs.d;
      recursive = true;
    };
  });
}
