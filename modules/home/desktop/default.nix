{ host, ... }:
let
  inherit (import ../../../hosts/${host}/variables.nix) shellChoice waybarChoice;

  # Shell-specific imports based on shellChoice
  shellImports =
    if shellChoice == "dms" then
      [
        ./dms.nix
        # rofi, wlogout, stylix not needed - DMS has built-in alternatives
      ]
    else
      [
        ./awww.nix
        waybarChoice
        ./swaync.nix
        ./rofi
        ./wlogout
        ./stylix.nix
      ];
in
{
  # GNOME Keyring SSH socket (only for desktop)
  home.sessionVariables = {
    SSH_AUTH_SOCK = "/run/user/1000/gcr/ssh";
  };

  imports = [
    ./dev
    ./hyprland
    ./scripts
    ./appimages.nix
    ./cava.nix
    ./cliphist.nix
    # ./ghostty.nix
    ./gtk.nix
    # ./kitty.nix
    ./qt.nix
    ./swappy.nix
    # ./upwork.nix
    ./virtmanager.nix
    ./wezterm.nix
    ./xdg.nix
  ]
  ++ shellImports;
}
