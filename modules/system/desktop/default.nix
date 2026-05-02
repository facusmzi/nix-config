{ config, lib, pkgs, ... }:
{
  imports = [
    ./plasma.nix
    ./browsers
  ];
}
