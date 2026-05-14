{ inputs, config, pkgs, ... }:
{
  imports = [ inputs.ewm.nixosModules.default ];

  environment.sessionVariables = {
    XKB_DEFAULT_LAYOUT = "latam";
    XKB_DEFAULT_OPTIONS = "ctrl:nocaps";
  };

  environment.systemPackages = with pkgs; [
    wl-clipboard brightnessctl
    grim slurp
  ];

  programs.ewm = {
    enable = true;
    # finalPackage es el emacs30-pgtk con todos tus paquetes de home-manager
    # ewm.nix
    emacsPackage = config.home-manager.users.facusmzi.programs.doom-emacs.finalEmacsPackage;
  };
}
