{ pkgs, ... }:
{
  programs.emacs = {
    enable = true;
    package = pkgs.emacs30-pgtk;
    extraPackages = epkgs: with epkgs; [
      catppuccin-theme
      doom-themes
      vertico
      orderless
      marginalia
      consult
      helpful
      all-the-icons
      doom-modeline
      rainbow-delimiters
      which-key
      projectile
      magit
      org-modern
      markdown-mode
      nix-mode
      diminish
      sudo-edit
      dashboard
      corfu
      cape
      dap-mode   
      envrc      
    ];
  };

  home.file.".config/emacs" = {
    source = ./emacs.d;
    recursive = true;
  };
}
