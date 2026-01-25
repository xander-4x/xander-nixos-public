{...}: let
  inherit (import ./variables.nix) nvidiaID amdgpuID;
in {
  imports = [
    # Host-specific
    ./hardware.nix
    ./host-packages.nix
    ./user.nix
    ./zram.nix

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

  # GPU drivers
  drivers.amdgpu.enable = true;
  drivers.nvidia.enable = true;
  drivers.nvidia-prime = {
    enable = true;
    amdBusID = "${amdgpuID}";
    nvidiaBusID = "${nvidiaID}";
  };
  drivers.intel.enable = false;
  vm.guest-services.enable = false;

  services.udev.extraRules = ''
    # NVIDIA GPU
    KERNEL=="card[0-9]*", SUBSYSTEM=="drm", DRIVERS=="nvidia", SYMLINK+="dri/card-nvidia"
    # AMD GPU
    KERNEL=="card[0-9]*", SUBSYSTEM=="drm", DRIVERS=="amdgpu", SYMLINK+="dri/card-amd"
  '';

  system.stateVersion = "23.11";
}
