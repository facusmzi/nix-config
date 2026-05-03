{ config, lib, pkgs, ... }:
{
  imports = [
    ./plasma.nix
    #./gnome.nix
    ./browsers
  ];
}
