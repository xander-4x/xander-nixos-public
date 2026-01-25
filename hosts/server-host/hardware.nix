# Generate this file with:
# sudo nixos-generate-config --show-hardware-config > hosts/desktop/hardware.nix
{
  config,
  lib,
  modulesPath,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "ahci"
    "usb_storage"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ]; # or kvm-intel for Intel CPUs
  boot.extraModulePackages = [ ];

  # Example filesystem configuration - replace with your actual UUIDs
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/YOUR-ROOT-UUID";
    fsType = "ext4"; # or btrfs
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/YOUR-BOOT-UUID";
    fsType = "vfat";
  };

  swapDevices = [ ];

  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
