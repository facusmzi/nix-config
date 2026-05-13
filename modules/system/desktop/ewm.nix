{ inputs, pkgs, ... }:
{
  imports = [ inputs.ewm.nixosModules.default ];

  environment.systemPackages = with pkgs; [

    wl-clipboard brightnessctl

  ];

  programs.ewm = {
    enable = true;
    screencast.enable = true;
    # emacsPackage se toma del default (emacs-pgtk)
    # si querés usar tu emacs30-pgtk:
     emacsPackage = pkgs.emacs30-pgtk;
  };
}
