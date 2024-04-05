{ config, pkgs, ... }:

{ 
  home.packages = [
    ( pkgs.nerdfonts.override { fonts = [ "FiraCode" "RobotoMono" ]; })
  ];  
  # Kitty config
  programs.kitty = {
    enable = true;
    theme = "Alabaster Dark";
    
    # font.name = "RobotoMono Nerd Font Mono Regular";
    font.name = "FiraCode Nerd Font Mono";
    # font.name = "JuliaMono Regular";
  };
}
