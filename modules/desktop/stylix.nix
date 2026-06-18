{
  pkgs,
  host,
  ...
}:
let
  inherit (import ../../hosts/${host}/variables.nix) stylixImage cursorName cursorSize;
in
{
  # Styling Options
  stylix = {
    enable = true;
    # image = stylixImage;
    # Catppuccin Macchiato color scheme
    # Other flavors: latte (light), frappe, macchiato, mocha (darkest)
    base16Scheme = {
      base00 = "24273a"; # Base
      base01 = "1e2030"; # Mantle
      base02 = "363a4f"; # Surface0
      base03 = "494d64"; # Surface1
      base04 = "5b6078"; # Surface2
      base05 = "cad3f5"; # Text
      base06 = "f4dbd6"; # Rosewater
      base07 = "b7bdf8"; # Lavender
      base08 = "ed8796"; # Red
      base09 = "f5a97f"; # Peach
      base0A = "eed49f"; # Yellow
      base0B = "a6da95"; # Green
      base0C = "8bd5ca"; # Teal
      base0D = "8aadf4"; # Blue
      base0E = "c6a0f6"; # Mauve
      base0F = "f0c6c6"; # Flamingo
    };
    # Theme polarity: "dark", "light", or "either" (auto-detect from wallpaper)
    polarity = "dark";
    opacity.terminal = 1.0;
    cursor = {
      package = pkgs.bibata-cursors;
      name = cursorName;
      size = cursorSize;
    };
    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrains Mono";
      };
      sansSerif = {
        package = pkgs.montserrat;
        name = "Montserrat";
      };
      serif = {
        package = pkgs.montserrat;
        name = "Montserrat";
      };
      sizes = {
        applications = 11;
        terminal = 11;
        desktop = 11;
        popups = 11;
      };
    };
  };
}
