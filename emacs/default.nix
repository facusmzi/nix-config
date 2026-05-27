{ config, pkgs, lib, inputs, ... }:
let
  users = [ "facusmzi" ];
in
{
  fonts.packages = with pkgs; [
    #     iosevka-comfy.comfy
    #     nerd-fonts.fira-code
    #     roboto
  ];

  environment.systemPackages = with pkgs; [
    ripgrep  alejandra
    nixd
  ];

  home-manager.users = lib.genAttrs users (username: {
    programs.emacs = {
      enable = true;
      package = pkgs.emacs30-pgtk;
      extraPackages = epkgs: with epkgs; [
       # UI
        dracula-theme
        vertico
        orderless
        marginalia
        consult
        nix-mode
        haskell-mode
        
        # Git
        magit

        # Autocompletado inline
        corfu

        # Entorno
        envrc

        # AI
        gptel


         # modal editing
        evil
        evil-collection

        # undo backend para evil
        undo-tree

        # dispatcher
        hydra

        # mejor help buffers
        helpful

        # editar grep results
        wgrep


         cape       
        
        
      ];
    };

    home.file.".config/emacs" = {
      source = ./emacs.d;
      recursive = true;
    };
  });
}
