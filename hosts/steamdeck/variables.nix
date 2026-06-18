{
  # Git Configuration
  gitUsername = "NixOS User";
  gitEmail = "user@example.com";

  # Console keymap
  consoleKeyMap = "us";

  # NFS server (off on handheld)
  enableNFS = false;

  # Boot directly into Steam Gaming Mode (SDDM autologin → gamescope-session).
  # Set false to land at the SDDM login screen and pick a session manually.
  autoStart = true;

  # Desktop session reachable from Gaming Mode's «Switch to Desktop» tile.
  # Set null to hide the tile entirely.
  desktopSession = "plasma";

  # Enable Decky Loader (plugin host for Steam UI).
  enableDeckyLoader = true;
}
