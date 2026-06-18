{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.desktop.plasma;
in
{
  options.desktop.plasma = {
    enable = mkEnableOption "Enable minimal KDE Plasma 6 desktop session (no display manager)";
  };

  config = mkIf cfg.enable {
    services.desktopManager.plasma6.enable = true;

    services.displayManager.sddm.settings.General.InputMethod = "qtvirtualkeyboard";

    # Strip stock Plasma bloat.
    environment.plasma6.excludePackages = with pkgs.kdePackages; [
      discover
      kate
      khelpcenter
      konsole          # replaced by wezterm
      kwallet          # no secrets manager needed
      kwallet-pam      # disables kwallet PAM integration at login
      kwalletmanager
      kwrited
      oxygen
      plasma-browser-integration
      plasma-systemmonitor  # replaced by htop/btop
      plasma-workspace-wallpapers
      qrca
    ];

    environment.systemPackages = with pkgs; [ qt6Packages.qtvirtualkeyboard ]
      ++ (with pkgs.kdePackages; [
        ark
        dolphin
        gwenview
        plasma-keyboard  # Wayland-native OSK; KWin shows it on touch focus
      ]);

    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.kdePackages.xdg-desktop-portal-kde ];
    };
  };
}
