{ pkgs, ... }:

{
  home.packages = [
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
