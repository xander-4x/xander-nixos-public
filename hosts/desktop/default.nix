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

  system.stateVersion = "23.11";
}
