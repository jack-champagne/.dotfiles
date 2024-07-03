# Hyprland config
{ pkgs, config, ... }:

let
  # Define a variable to store the number of workspaces
  numWorkspaces = 10;
  workspaceNumberList = builtins.genList (x: if x+1 < numWorkspaces then x+1 else 0) numWorkspaces;
  # Define the custom list based on the number of workspaces
  workspaceBinds = builtins.map (e: "$mod, " + builtins.toString e + ", workspace, " + builtins.toString e) workspaceNumberList;
  moveToWorkspaceBinds = builtins.map (e: "$mod SHIFT, " + builtins.toString e + ", movetoworkspace, " + builtins.toString e) workspaceNumberList;
in

{
  home.packages = with pkgs; [
    wayland-scanner
    bemenu
    hyprpaper
  ];

  home.file.".config/hypr/hyprpaper.conf".text = ''
    preload = /home/jack/repos/wallpapers/ac9b41bd405e7c5b67ab9412c958c586.jpg
    preload = /home/jack/repos/wallpapers/fudsilsjjc301.jpg
    #if more than one preload is desired then continue to preload other backgrounds
    
    wallpaper = WL-1,/home/jack/repos/wallpapers/fudsilsjjc301.jpg
    wallpaper = DP-1,/home/jack/repos/wallpapers/ac9b41bd405e7c5b67ab9412c958c586.jpg
    wallpaper = HDMI-A-1,/home/jack/repos/wallpapers/fudsilsjjc301.jpg

    #enable ipc
    ipc = on

    #enable splash text rendering over the wallpaper
    splash = false
  '';

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      exec-once = [ "mako" "hyprpaper"];

      monitor = [ 
        "DP-1,2560x1440@120,0x0,1" 
        "WL-1,preferred,auto,1.0"
      ];

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

      animations = {
        enabled = true;
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [ 
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      master = { new_status = "master"; };
 
      misc = { 
        vfr = true;
        force_default_wallpaper = 0;
      };

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
      ] ++ [
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"
      ] ++ workspaceBinds ++ moveToWorkspaceBinds ++ [
        "$mod, S, togglespecialworkspace, magic"
        "$mod SHIFT, S, movetoworkspace, special:magic"
      ];

      bindr = [
        "$mod, P, execr, pkill bemenu-run || bemenu-run"
      ];

      debug.disable_logs = false; 
    };
  };
}
