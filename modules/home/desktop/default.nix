{host, ...}: let
  inherit (import ../../../hosts/${host}/variables.nix) waybarChoice;
in {
  imports = [
    ./dev
    ./hyprland
    ./rofi
    ./scripts
    ./wlogout
    waybarChoice
    ./appimages.nix
    ./cava.nix
    # ./ghostty.nix
    ./gtk.nix
    # ./kitty.nix
    ./qt.nix
    ./stylix.nix
    ./swappy.nix
    ./swaync.nix
    # ./upwork.nix
    ./virtmanager.nix
    ./wezterm.nix
  ];
}
