{ pkgs, lib, host, ... }:
let
  inherit (import ../../../hosts/${host}/variables.nix) shellChoice;
in {
  home.packages = lib.optionals (shellChoice == "dms") [
    pkgs.glib # for gsettings
    # Cursor themes for DMS selection
    pkgs.bibata-cursors
    pkgs.catppuccin-cursors.mochaDark
    pkgs.adwaita-icon-theme # includes Adwaita cursor
  ];

  # Set GTK theme via dconf for Wayland apps
  dconf.settings = lib.optionalAttrs (shellChoice == "dms") {
    "org/gnome/desktop/interface" = {
      gtk-theme = "adw-gtk3-dark";
      icon-theme = "Papirus-Dark";
      color-scheme = "prefer-dark";
    };
  };

  gtk = {
    enable = true;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    # Use adw-gtk3 theme for DMS matugen compatibility
    theme = if shellChoice == "dms" then {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    } else {};
    gtk3 = {
      extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
      # Import DMS-generated colors
      extraCss = if shellChoice == "dms" then ''
        @import url("dank-colors.css");
      '' else "";
    };
    gtk4 = {
      extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
      extraCss = if shellChoice == "dms" then ''
        @import url("dank-colors.css");
      '' else "";
    };
  };
}
