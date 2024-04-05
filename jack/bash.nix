{ config, pkgs, ... }:

{ 
  home.packages = with pkgs; [
    eza
  ];

  # Bash dotfiles
  programs.bash = {
    enable = true;
    shellAliases = {
      ls = "eza -lah --icons --group-directories-first --octal-permissions --git";
      lt = "eza -lah --icons --group-directories-first --tree --level 5";
      ".." = "cd ..";
    };
  };
}
