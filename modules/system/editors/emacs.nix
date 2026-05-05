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
  # ─── Configuración de Fuentes ──────────────────────────────
  # Esto soluciona los errores de 'Symbola' y 'Nerd Fonts' del doctor
  fonts.packages = with pkgs; [
    symbola
    # En versiones nuevas, seleccionas la fuente directamente del set nerd-fonts
    nerd-fonts.terminess-ttf
  ];

  # ─── Sistema ───────────────────────────────────────────────
  environment.systemPackages = with pkgs; [
    # Dependencias de compilación para vterm y utilidades base
    cmake
    libtool
    libvterm-neovim
    coreutils

    hunspell
    hunspellDicts.es_ES
    hunspellDicts.en_US
  ];

  # ─── Home Manager ──────────────────────────────────────────
  home-manager.users = lib.genAttrs users (
    username:
    { config, ... }:
    {
      programs.doom-emacs = {
        enable = true;
        doomDir = ./doom;
        doomLocalDir = "${config.home.homeDirectory}/.local/share/doom";
        emacs = pkgs.emacs30-pgtk;
        experimentalFetchTree = true;

        extraPackages = epkgs: [
          epkgs.treesit-grammars.with-all-grammars
          epkgs.vterm
        ];

        extraBinPackages = with pkgs; [
          # Herramientas de búsqueda (indispensables para Doom)
          fd
          (ripgrep.override { withPCRE2 = true; })

          # Vterm & Tools
          gnumake
          sqlite # Necesario para el módulo (lookup +docsets)

          # --- Correctores ortográficos ---
          hunspell
          hunspellDicts.es_ES # Diccionario en español
          hunspellDicts.en_US # Diccionario en inglés

          # Haskell[cite: 2]
          haskell-language-server
          haskellPackages.hoogle # <--- Cambia 'hoogle' por esto
          cabal-install
          ormolu

          # Rust[cite: 2]
          rust-analyzer
          cargo
          rustc

          # Markdown & Org
          pandoc # Compilador para markdown[cite: 2]
          graphviz # Provee 'dot' para los gráficos de org-roam[cite: 2]

          # Shell
          shfmt
          shellcheck
        ];
      };

      # Dentro de home-manager.users.facusmzi en emacs.nix
      # Dentro de home-manager.users.facusmzi en emacs.nix
      home.sessionVariables = {
        # Esta ruta apunta a donde Nix instala los diccionarios del sistema
        DICPATH = "/run/current-system/sw/share/hunspell";
      };

      home.sessionPath = [ "$HOME/.config/emacs/bin" ];
    }
  );
}
