{ lib, config, pkgs, ... }:
{
  home.packages = with pkgs; [ rclone fuse3 ];
  systemd.user.settings.Manager.DefaultEnvironment = {
    PATH = "$PATH:${lib.makeBinPath [ pkgs.rclone pkgs.fuse3 ]}";
  };
  systemd.user.services.rclonemount-cmu-drive = {
    Unit = {
      Description = "rclone mount for CMU google drive";
      After = [ "network-online.target" ];
      Wants = [ "network-online.target" ];
    };

    Service = {
      TimeoutStartSec = 10;
      RestartSec = 5;
      Restart = "on-failure";
      ExecStart =''${pkgs.rclone}/bin/rclone mount remote: /home/jack/Documents/Drive'';
      # ExecStop = ''${pkgs.fuse3}/bin/fusermount3 -uz /home/jack/Documents/Drive'';
    };

    Install.WantedBy = [ "default.target" ];
  };
}
