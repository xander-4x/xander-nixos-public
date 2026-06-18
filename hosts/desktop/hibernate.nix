{ ... }: {
  # Btrfs subvolume for swapfile — no compression, no CoW
  # Before first deploy: create @swap subvolume and swapfile manually.
  #
  # Then fill in the UUID and offset below:
  #   UUID: blkid /dev/sdX (your LUKS device or plain partition)
  #   offset: sudo btrfs inspect-internal map-swapfile -r /swap/swapfile
  fileSystems."/swap" = {
    device = "/dev/disk/by-uuid/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX";
    fsType = "btrfs";
    options = [ "subvol=@swap" "noatime" ];
  };

  swapDevices = [{
    device = "/swap/swapfile";
  }];

  # LUKS decrypted device + btrfs physical offset for hibernate resume.
  boot.resumeDevice = "/dev/mapper/cryptroot";
  boot.kernelParams = [ "resume_offset=XXXXXXXXXX" ];

  # suspend-then-hibernate: fast resume if woken quickly,
  # full power-off after 30 min — ideal for backpack transport
  services.logind.settings.Login = {
    HandlePowerKey = "ignore";
    HandleLidSwitch = "suspend-then-hibernate";
    HandleLidSwitchExternalPower = "suspend";
  };
  systemd.sleep.settings.Sleep.HibernateDelaySec = "30min";
}
