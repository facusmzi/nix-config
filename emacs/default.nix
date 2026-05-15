{ config, pkgs, lib, inputs, ... }:
let
  users = [ "facusmzi" ];
in
{
  fonts.packages = with pkgs; [
    iosevka-comfy.comfy
    nerd-fonts.fira-code
    roboto
  ];

  environment.systemPackages = with pkgs; [
    ripgrep
  ];

  home-manager.users = lib.genAttrs users (username: {
    programs.emacs = {
      enable = true;
      package = pkgs.emacs30-pgtk;
      extraPackages = epkgs: with epkgs; [
        # UI
        doom-themes
        doom-modeline
        nerd-icons
        nerd-icons-dired

        # Evil
        evil
        undo-tree

        # Editor
        envrc
        which-key

        # VC
        magit

        hydra
        eat
      ];
    };

    home.file.".config/emacs" = {
      source = ./emacs.d;
      recursive = true;
    };
  });
}
