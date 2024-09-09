{ config, pkgs, lib, ... }:

{
  # TODO: change ocrl into shell.nix thingy
  imports =
    [
      ./hypr.nix
      ./emacs.nix
      ./bash.nix
      ./kitty.nix
      ./ocrl.nix
    ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "jack";
  home.homeDirectory = "/home/jack";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
    julia-mono
    keepassxc
    rclone
    mako
    virt-manager
    unzip
    gparted
    waypipe
    pulseaudio # just for pulseaudio utilities for piping audio over the network
    btop
    # docker
    xdg-utils
    wayshot
    slurp
    # kde-cli-tools
    cloudflared
    discord
    vorta
    gh
    jq
    slack
    obsidian
    vscode
    kdenlive
    gnome.nautilus
  ];

  # Add themeing options (currently just gtk) - ripped from https://github.com/NixOS/nixpkgs/issues/207339#issuecomment-1374497558
  gtk = {
    enable = true;
    theme = {
      package = pkgs.gnome.gnome-themes-extra;
      name = "Adwaita-dark";
    };
  };

  
  # some other dark theming stuffs - taken from https://nixos.wiki/wiki/GNOME
  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };
  };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/jack/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  programs.gpg = {
    enable = true;
    # mutableKeys = false;
  };

  programs.git = {
    enable = true;
    userName = "Jack Champagne";
    userEmail = "jackchampagne.r@gmail.com";
    extraConfig = {
      init = {
        defaultBranch = "main";
      };
      credential.helper = "store";
    };
  };

  xdg = {
    enable = true;
    desktopEntries.emx = {
      exec = "/home/jack/.nix-profile/bin/emacsclient -c";
      name = "emx";
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
