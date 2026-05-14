{ config, pkgs, lib, inputs, ... }:

let
  users = [ "facusmzi" ];
in
{
  fonts.packages = with pkgs; [
    symbola
    nerd-fonts.terminess-ttf
    nerd-fonts.symbols-only
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    roboto
  ];

  environment.systemPackages = with pkgs; [
    cmake
    libtool
    libvterm-neovim
    coreutils
  ];

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
          fd
          (ripgrep.override { withPCRE2 = true; })
          gnumake
          sqlite
          pandoc
          graphviz
          shfmt
          shellcheck
        ];
      };
    }
  );
}
