{ pkgs, lib, ... }:

let
  users = [ "facusmzi" ];

  vscode-fhs = pkgs.vscode.fhsWithPackages (ps: with ps; [
    nil
    alejandra
    zlib
    openssl
    git
  ]);

in
{
  # ─── Sistema ─────────────────────────────────────────────────────────
  environment.systemPackages = [
    vscode-fhs
    pkgs.nil
    pkgs.alejandra
  ];

  # ─── Home Manager ────────────────────────────────────────────────────
  home-manager.users = lib.genAttrs users (_: {

    programs.vscode = {
      enable = true;
      package = vscode-fhs;

      profiles.default = {

        extensions = with pkgs.vscode-extensions; [
          jnoortheen.nix-ide
          rust-lang.rust-analyzer
          haskell.haskell
          justusadam.language-haskell
          eamodio.gitlens
          mkhl.direnv
          usernamehw.errorlens
          gruntfuggly.todo-tree
        ];

        userSettings = {
          "editor.fontFamily"          = "'JetBrainsMono Nerd Font', 'monospace'";
          "editor.fontSize"            = 14;
          "editor.lineHeight"          = 1.6;
          "editor.tabSize"             = 2;
          "editor.insertSpaces"        = true;
          "editor.formatOnSave"        = true;
          "editor.minimap.enabled"     = false;
          "editor.renderLineHighlight" = "all";
          "editor.bracketPairColorization.enabled" = true;
          "workbench.colorTheme"       = "Default Dark Modern";
          "workbench.startupEditor"    = "none";
          "terminal.integrated.fontFamily" = "'JetBrainsMono Nerd Font'";
          "files.autoSave"             = "onFocusChange";
          "explorer.confirmDelete"     = false;

          "nix.enableLanguageServer"   = true;
          "nix.serverPath"             = "nil";
          "nix.serverSettings".nil.formatting.command = [ "alejandra" ];

          "rust-analyzer.check.command" = "clippy";
          "rust-analyzer.cargo.buildScripts.enable" = true;

          "haskell.manageHLS"          = "PATH";
          "haskell.formattingProvider" = "fourmolu";

          "telemetry.telemetryLevel"   = "off";
          "extensions.autoCheckUpdates" = false;
        };

        keybindings = [
          { key = "ctrl+shift+`"; command = "workbench.action.terminal.new"; }
          { key = "ctrl+w";       command = "workbench.action.closeActiveEditor"; }
        ];
      };
    };
  });
}
