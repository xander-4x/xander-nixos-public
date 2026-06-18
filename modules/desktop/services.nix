{ host, ... }:
{
  # Disable wait-online for faster boot (not needed for desktop)
  systemd.services.NetworkManager-wait-online.enable = false;

  # Core services (no desktop dependencies)
  services = {
    libinput.enable = true; # Input Handling
    fstrim.enable = true; # SSD Optimizer
    btrfs.autoScrub = {
      enable = true;
      interval = "monthly";
    };
    gvfs.enable = true; # For Mounting USB & More
    openssh.enable = true; # Enable SSH
    tumbler.enable = true; # Image/video preview
    tailscale.enable = true; # tailscale
    gnome.gnome-keyring.enable = true;
    upower.enable = true; # Battery monitoring for DMS/waybar widgets
    accounts-daemon.enable = true; # AccountsService for DMS avatar persistence

    smartd = {
      enable = if host == "vm" then false else true;
      autodetect = true;
    };

    hardware.bolt.enable = true;
    fwupd.enable = true; # Firmware updates via LVFS

    udev.extraRules = ''
      # Ignore «touchpad» DualSense
      SUBSYSTEM=="input", ATTRS{name}=="*DualSense*Touchpad*", ENV{LIBINPUT_IGNORE_DEVICE}="1"
    '';
  };
}
