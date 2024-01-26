# Hyprland config
{ pkgs, config, ... }:

{
  home.packages = with pkgs; [
    bemenu
    sl
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      exec-once = [ "mako" ];

      monitor = [ "DP-1,2560x1440@120,0x0,1"];

      input = {
        kb_layout = "us";
        kb_options = "ctrl:swapcaps";
      };

      general = {
        gaps_in = 2;
        gaps_out = 10;
        border_size = 3;
        "col.active_border" = "rgba(ff0000ff) rgba(ffff00ff) rgba(00ffffff) rgba(0000ffff) rgba(ff00ffff) 10deg";
        "col.inactive_border" = "rgba(59595977)";
        layout = "master";
      };

      # below is taken from personal nixos config on arch laptop settings example
      decoration = {
        rounding = 10;
        blur = {
          enabled = false;
        };
        drop_shadow = false;
      };

      master = { new_is_master = true; };
 
      misc = { vfr = true; };

      "$mod" = "SUPER";
      bindm = [
        # mouse movements
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
        "$mod ALT, mouse:272, resizewindow"
      ];

      "$terminal" = "kitty";

      bind = [
        "$mod, Q, exec, $terminal"
        "$mod SHIFT, C, killactive,"
        "$mod, W, exec, firefox"
        "$mod, V, togglefloating,"
        "$mod, M, exit,"
      ];
      bindr = [
        "$mod, P, execr, pkill bemenu-run || bemenu-run"
      ]; 
    };
  };
}
