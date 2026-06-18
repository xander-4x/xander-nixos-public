{
  host,
  config,
  pkgs,
  ...
}: let
  inherit
    (import ../../../hosts/${host}/variables.nix)
    stylixImage
    ;
in {
  home.packages = [ pkgs.awww ];

  systemd.user.services.swww-daemon = {
    Unit = {
      Description = "swww background wallpaper daemon";
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.awww}/bin/awww-daemon";
      Restart = "on-failure";
      RestartSec = 2;
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  systemd.user.services.swww-wallpaper = {
    Unit = {
      Description = "Set wallpaper with swww";
      After = [ "swww-daemon.service" ];
      Requires = [ "swww-daemon.service" ];
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.awww}/bin/awww img ${stylixImage}";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
