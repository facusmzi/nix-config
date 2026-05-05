{ config, pkgs, lib, inputs, ... }:

let
  users = [ "facusmzi" ];
in
{
  # ─── Sistema ───────────────────────────────────────────────
  environment.systemPackages = with pkgs; [
    emacs

    # Dependencias para vterm
    cmake
    libtool
    libvterm-neovim

    # Herramientas para doom
    fd
    (ripgrep.override { withPCRE2 = true; })
    coreutils
  ];

  # ─── Home Manager ──────────────────────────────────────────
  home-manager.users = lib.genAttrs users (username: { config, ... }: {
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
        fd
        (ripgrep.override { withPCRE2 = true; })
        haskell-language-server
        ormolu
      ];
    };

    home.sessionPath = [ "$HOME/.config/emacs/bin" ];
  });
}
