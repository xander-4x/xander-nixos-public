{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.drivers.amdgpu;
in {
  options.drivers.amdgpu = {
    enable = mkEnableOption "Enable AMD Drivers";
  };

  config = mkIf cfg.enable {
    systemd.tmpfiles.rules = ["L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"];

    # Prevent Data Fabric Sync Flood crashes during GPU+memory load (hybrid AMD+NVIDIA systems)
    boot.kernelParams = [
      "amdgpu.gttsize=8192"      # Fixed GTT size instead of dynamic allocation
      "amdgpu.vm_update_mode=3"  # CPU-based VM updates (more stable with dGPU)
      "amd_pstate=passive"       # Less aggressive power management
      "pci=noaer"                # Disable PCIe AER (reduces sync flood triggers)
    ];

    # Load msr module for zenstates
    boot.kernelModules = [ "msr" ];

    # Disable C6 state on boot to prevent Data Fabric Sync Flood crashes
    # C6 is the deepest sleep state and causes instability on some Ryzen CPUs
    # This preserves C1-C5 for power saving while avoiding the problematic C6
    systemd.services.disable-c6 = {
      description = "Disable AMD Ryzen C6 state to prevent sync flood crashes";
      wantedBy = [ "multi-user.target" ];
      after = [ "systemd-modules-load.service" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.zenstates}/bin/zenstates --c6-disable";
        RemainAfterExit = true;
      };
    };
  };
}
