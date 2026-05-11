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
      eat

      # Rust
      rustic        # modo principal: syntax, cargo commands, eglot integration
      cargo-mode    # comandos de cargo extra (cargo-execute-task, etc.)

      consult-eglot
      tempel
      tempel-collection
      breadcrumb
      yasnippet

      # Lectura
      pdf-tools
      nov
      pdf-view-restore

      # ventanas
      ace-window
    ];
  };

  home.file.".config/emacs" = {
    source = ./emacs.d;
    recursive = true;
  };
}
