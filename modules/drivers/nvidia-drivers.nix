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

      powerManagement.enable = true;
      powerManagement.finegrained = true;

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
      "nvidia.NVreg_EnableS0ixPowerManagement=1"
    ];

    boot.extraModulePackages = with config.boot.kernelPackages; [
      acpi_call
    ];
    
    boot.kernelModules = [ "acpi_call" "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];
    
    boot.initrd.kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];

    hardware.graphics.extraPackages32 = with pkgs.pkgsi686Linux; [
      libva-vdpau-driver
      libva
    ];

    # Systemd services for suspend
    systemd.services.nvidia-display-suspend = {
      description = "Turn off displays before suspend";
      before = [ "systemd-suspend.service" ];
      wantedBy = [ "systemd-suspend.service" ];
      serviceConfig = {
        Type = "oneshot";
        User = "root";
        ExecStart = "${pkgs.bash}/bin/bash -c 'for gpu in /sys/class/drm/card*/device/power/control; do echo auto > $gpu; done'";
      };
    };

    systemd.services.nvidia-display-resume = {
      description = "Restore displays after resume";
      after = [ "systemd-suspend.service" "nvidia-resume.service" ];
      wantedBy = [ "systemd-suspend.service" ];
      serviceConfig = {
        Type = "oneshot";
        User = "root";
        ExecStart = "${pkgs.bash}/bin/bash -c 'sleep 2 && for gpu in /sys/class/drm/card*/device/power/control; do echo on > $gpu; done'";
      };
    };

    # Systemd services for hibernate
    systemd.services.nvidia-display-hibernate = {
      description = "Turn off displays before hibernate";
      before = [ "systemd-hibernate.service" ];
      wantedBy = [ "systemd-hibernate.service" ];
      serviceConfig = {
        Type = "oneshot";
        User = "root";
        ExecStart = "${pkgs.bash}/bin/bash -c 'for gpu in /sys/class/drm/card*/device/power/control; do echo auto > $gpu; done'";
      };
    };

    systemd.services.nvidia-display-hibernate-resume = {
      description = "Restore displays after hibernate";
      after = [ "systemd-hibernate.service" "nvidia-resume.service" ];
      wantedBy = [ "systemd-hibernate.service" ];
      serviceConfig = {
        Type = "oneshot";
        User = "root";
        ExecStart = "${pkgs.bash}/bin/bash -c 'sleep 3 && for gpu in /sys/class/drm/card*/device/power/control; do echo on > $gpu; done'";
      };
    };

    programs.hyprland.enable = mkDefault true;
  };
}