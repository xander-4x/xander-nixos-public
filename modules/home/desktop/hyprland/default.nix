{host, ...}: let
  inherit (import ../../../../hosts/${host}/variables.nix) animChoice shellChoice;

  # DMS replaces hypridle and hyprlock
  dmsReplacedImports = if shellChoice == "dms" then [] else [
    ./hypridle.nix
    ./hyprlock.nix
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
