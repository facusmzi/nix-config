# modules/system/editors/latex.nix
{ pkgs, ... }:
{
  environment.systemPackages = [
    (pkgs.texlive.withPackages (ps: with ps; [
      scheme-basic
      dvisvgm
      dvipng
      wrapfig
      amsmath
      ulem
      hyperref
      capt-of
    ]))
  ];
}
