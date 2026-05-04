{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    nixd
    nixfmt-rfc-style
    nix-tree        # ver dependencias del store visualmente
    nix-diff        # comparar dos derivaciones
  ];
}
