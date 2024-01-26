{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    julia-lts
    jupyter
    pandoc
    texliveFull
    inkscape
    poppler_utils
  ];
}
