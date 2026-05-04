{ pkgs, config, ... }:

{
  programs.doom-emacs = {
    enable = true;
    doomDir = ./doom;
    doomLocalDir = "${config.home.homeDirectory}/.local/share/doom";
    emacs = pkgs.emacs30-pgtk;
    experimentalFetchTree = true;
    extraPackages = epkgs: [ epkgs.treesit-grammars.with-all-grammars ];
    extraBinPackages = with pkgs; [
      fd ripgrep
      haskell-language-server
      ormolu
    ];
  };
}
