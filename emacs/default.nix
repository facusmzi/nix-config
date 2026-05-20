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
    #     ripgrep
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
        rainbow-delimiters
	      nix-mode
        lsp-mode
        lsp-ui

	      # Git
	      magit

	      # Autocompletado inline
	      corfu
        envrc


        # org-mode
        org-modern

        # utilidades
        helpful
        avy
        
        
      ];
    };

    home.file.".config/emacs" = {
      source = ./emacs.d;
      recursive = true;
    };
  });
}
