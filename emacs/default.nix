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
  ];

  environment.systemPackages = with pkgs; [
    ripgrep
  ];

  home-manager.users = lib.genAttrs users (username: {
    programs.emacs = {
      enable = true;
      package = pkgs.emacs30-pgtk;
      extraPackages = epkgs: with epkgs; [
        ef-themes
        doom-modeline
      ];
    };

    home.file.".config/emacs".source = ./emacs.d;
  });
}
