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
  fonts.packages = with pkgs; [
    symbola
    nerd-fonts.terminess-ttf
    nerd-fonts.symbols-only
  ];

  # ─── Sistema ───────────────────────────────────────────────
  environment.systemPackages = with pkgs; [
    cmake
    libtool
    libvterm-neovim
    coreutils
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
          # Búsqueda (indispensable para Doom)
          fd
          (ripgrep.override { withPCRE2 = true; })

          # Vterm & Tools
          gnumake
          sqlite

          # Nix
          nixd
          nixfmt-rfc-style

          # Haskell
#           haskell-language-server
#           haskellPackages.hoogle
#           cabal-install
#           ormolu
#
#           # Rust
#           rust-analyzer
#           cargo
#           rustc

          # Markdown & Org
          pandoc
          graphviz

          # Shell
          shfmt
          shellcheck
        ];
      };
    }
  );
}
