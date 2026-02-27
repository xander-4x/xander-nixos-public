{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.drivers.nvidia;
in {
  options.drivers.nvidia = {
    enable = mkEnableOption "Enable Nvidia Drivers";
  };

  config = mkIf cfg.enable {
    services.xserver.videoDrivers = [ "nvidia" "amdgpu" ];

    hardware.nvidia = {
      modesetting.enable = true;

      powerManagement.enable = true;   # Preserve VRAM on suspend, RTD3 works on Ada Lovelace without finegrained
      powerManagement.finegrained = false;  # Disabled: causes crashes with external monitors (NVIDIA bug 5034343)

      open = false;
      nvidiaSettings = true;

      package = config.boot.kernelPackages.nvidiaPackages.stable;
      forceFullCompositionPipeline = true;
    };

    # Kernel parameters for NVIDIA suspend/resume and HDMI
    boot.kernelParams = [
      "nvidia-drm.modeset=1"
      "nvidia-drm.fbdev=1"
      "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
      "nvidia.NVreg_EnableS0ixPowerManagement=0"  # Disable S0ix - problematic on AMD
      "nvidia.NVreg_TemporaryFilePath=/var/tmp"
      "pcie_aspm=off"  # Disable PCIe ASPM - can cause Data Fabric Sync Flood on AMD
    ];

    # Workaround for NVIDIA 580.x black screen on resume
    boot.extraModprobeConfig = ''
      options nvidia_modeset vblank_sem_control=0
    '';

    boot.extraModulePackages = with config.boot.kernelPackages; [
      acpi_call
    ];
    
    boot.kernelModules = [ "acpi_call" "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];
    
    # Removed from initrd - early loading can cause suspend issues
    # boot.initrd.kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];

    hardware.graphics.extraPackages32 = with pkgs.pkgsi686Linux; [
      libva-vdpau-driver
      libva
    ];

    # Custom suspend/hibernate services removed - using standard nvidia-suspend/resume
    # which are enabled by NixOS when hardware.nvidia is configured

    programs.hyprland.enable = mkDefault true;
  };
}