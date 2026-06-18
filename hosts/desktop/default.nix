{...}: {
  imports = [
    # Host-specific
    ./hardware.nix
    ./host-packages.nix
    ./kernel-tuning.nix
    ./thinkpad.nix
    ./user.nix
    ./zram.nix
    ./hibernate.nix

    # Core system modules
    ../../modules/core

    # Desktop environment (GUI)
    ../../modules/desktop

    # Gaming
    ../../modules/gaming

    # Virtualisation (Podman, libvirt)
    ../../modules/virtualisation

    # Hardware drivers
    ../../modules/drivers
  ];

  drivers.intel.enable = true;
  vm.guest-services.enable = false;

  system.stateVersion = "23.11";
}
