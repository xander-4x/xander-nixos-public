{ pkgs, host, ... }:
let
  inherit (import ../../../hosts/${host}/variables.nix) cursorName cursorSize;
in {
  home.packages = with pkgs; [
    dms-shell
    quickshell # required - UI framework for DMS
    matugen # for Material Design color generation from wallpapers
    dgop # for CPU/memory usage widgets
    qt6Packages.qt6ct # for DMS QT color theming
  ];

  # Cursor managed via config (not DMS) for XWayland/Steam compatibility
  home.pointerCursor = {
    package = pkgs.bibata-cursors;
    name = cursorName;
    size = cursorSize;
    gtk.enable = true;
    x11.enable = true;
  };

  systemd.user.services.dms = {
    Unit = {
      Description = "DankMaterialShell";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.dms-shell}/bin/dms run";
      Restart = "on-failure";
      RestartSec = 3;
    };
    Install = {
      WantedBy = [ "hyprland-session.target" ];
    };
  };

  # Clipboard is built into dms run - no separate service needed
}
