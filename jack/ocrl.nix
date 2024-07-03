{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    julia
    jupyter
    pandoc
    texliveFull
    inkscape
    poppler_utils
    nodejs-18_x
  ];
}
