{ pkgs, ... }:
{
  programs.emacs = {
    enable = true;
    package = pkgs.emacs30-pgtk;
    extraPackages = epkgs: with epkgs; [
      catppuccin-theme
      ivy
      ivy-rich
      counsel
      helpful
      all-the-icons
      doom-modeline
      rainbow-delimiters
      which-key
      projectile
      counsel-projectile
      magit
      org-modern
      markdown-mode
      nix-mode
      diminish
    ];
  };

  home.file.".config/emacs" = {
    source = ./emacs.d;
    recursive = true;
  };
}
