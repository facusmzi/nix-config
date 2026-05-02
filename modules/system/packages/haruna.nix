{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    haruna
  ];
}
