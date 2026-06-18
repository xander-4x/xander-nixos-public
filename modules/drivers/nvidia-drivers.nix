{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.drivers.nvidia;
in {
  options.drivers.nvidia = {
    enable = mkEnableOption "Enable Nvidia Drivers";
  };

  config = mkIf cfg.enable {
    services.xserver.videoDrivers = [ "amdgpu" "nvidia" ];

    hardware.nvidia = {
      modesetting.enable = true;

      powerManagement.enable = true;
      # RTD3 — dGPU off when no process holds it (only spun up via nvidia-offload).
      # Safe without external monitors (NVIDIA bug 5034343 only triggers with HDMI/DP on dGPU).
      powerManagement.finegrained = true;

      open = false;
      nvidiaSettings = true;

      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };

    # Generic NVIDIA kernel params. Host-specific quirks (PCIe ASPM, IOMMU,
    # AMD S0ix interop, etc.) live in the host's own kernel-tuning module.
    boot.kernelParams = [
      "nvidia-drm.modeset=1"
      "nvidia-drm.fbdev=1"
      "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
      "nvidia.NVreg_TemporaryFilePath=/var/tmp"
    ];

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