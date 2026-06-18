{
  # Git Configuration ( For Pulling Software Repos )
  gitUsername = "NixOS User";
  gitEmail = "user@example.com";

  # Hyprland Settings
  extraMonitorSettings = "
    monitor=eDP-1,1920x1200@60,0x0,1
  ";

  # Waybar Settings
  clock24h = false;

  # Program Options
  browser = "brave-browser"; # Set Default Browser (.desktop name)
  browserExec = "brave"; # Browser executable
  terminal = "wezterm"; # Set Default System Terminal
  keyboardLayout = "us,ru";
  consoleKeyMap = "us";

  # For Nvidia Prime support (uncomment to enable):
  # amdgpuID = "PCI:36:0:0";
  # nvidiaID = "PCI:1:0:0";
  # nvidiaDRM = "/dev/dri/card-nvidia";
  # amdDRM = "/dev/dri/card-amd";

  # Enable NFS
  enableNFS = true;

  # Enable Printing Support
  printEnable = false;

  # Set Stylix Image
  stylixImage = ../../wallpapers/new-york.jpg;

  # Cursor Settings
  cursorName = "Bibata-Modern-Ice";
  cursorSize = 20;

  # Desktop shell choice
  # "dms" = DankMaterialShell (replaces waybar, swaync, hyprlock, hypridle)
  # "waybar" = traditional waybar + swaync setup
  shellChoice = "waybar";

  # Set Waybar (only used when shellChoice = "waybar")
  # Includes alternates such as waybar-simple.nix & waybar-ddubs.nix
  waybarChoice = ../../modules/home/desktop/waybar/waybar-curved.nix;

  # Set Animation style
  # Available options are:
  # animations-def.nix  (default)
  # animations-end4.nix (end-4 project)
  # animations-dynamic.nix (ml4w project)
  animChoice = ../../modules/home/desktop/hyprland/animations-end4.nix;

  # Enable Thunar GUI File Manager
  thunarEnable = true;
}
