{host, ...}: let
  inherit (import ../../../../hosts/${host}/variables.nix) animChoice shellChoice;

  # DMS replaces hypridle, hyprlock, and swww management
  dmsReplacedImports = if shellChoice == "dms" then [] else [
    ./hypridle.nix
    ./hyprlock.nix
    ./swww.nix
  ];
in {
  imports = [
    animChoice
    ./binds.nix
    ./hyprland.nix
    # ./pyprland.nix
    ./windowrules.nix
  ] ++ dmsReplacedImports;
}
