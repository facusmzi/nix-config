{ config, lib, pkgs, ... }:
{
  imports = [
    ./plasma.nix
    #./ewm.nix
    #./gnome.nix
    ./browsers
  ];
}
