{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.drivers.nvidia-prime;
in {
  options.drivers.nvidia-prime = {
    enable = mkEnableOption "Enable Nvidia Prime (reverseSync) for external displays on NVIDIA";
    nvidiaBusID = mkOption {
      type = types.str;
      default = "PCI:1:0:0";
      description = "BusID for NVIDIA dGPU (format PCI:X:Y:Z)";
    };
    amdBusID = mkOption {
      type = types.str;
      default = "PCI:36:0:0";
      description = "BusID for AMD iGPU (format PCI:X:Y:Z)";
    };
  };

  config = mkIf cfg.enable {
    hardware.nvidia = {
      prime = {
        # Use offload mode: AMD is primary, NVIDIA only when needed
        # External monitors will still work, but NVIDIA can be powered off when not in use
        amdgpuBusId = "${cfg.amdBusID}";
        nvidiaBusId = "${cfg.nvidiaBusID}";

        offload = {
          enable = true;
          enableOffloadCmd = true;  # Adds nvidia-offload command
        };

        # Alternative: use sync instead of reverseSync for better power management
        # sync.enable = true;

        allowExternalGpu = true;
      };
    };

    # Environment variables - use AMD by default for power saving
    environment.variables = {
      # AMD first for better battery life, NVIDIA second for external monitors
      WLR_DRM_DEVICES = "/dev/dri/card1:/dev/dri/card2";

      # Electron optimization for faster startup
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
      ELECTRON_NO_SANDBOX = "1";
      ELECTRON_DISABLE_SECURITY_WARNINGS = "true";
      # Use GPU acceleration for Electron apps
      CHROME_EXECUTABLE = "${pkgs.chromium}/bin/chromium";
    };

    systemd.services.nvidia-monitor-detection = {
      description = "Force NVIDIA monitor detection on startup";
      wantedBy = [ "graphical-session.target" ];
      after = [ "display-manager.service" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "${pkgs.xrandr}/bin/xrandr --auto";
        User = "root";
      };
    };

    programs.hyprland.enable = mkDefault true;

    # GPU symlinks for easier device identification
    services.udev.extraRules = ''
      KERNEL=="card[0-9]*", SUBSYSTEM=="drm", DRIVERS=="nvidia", SYMLINK+="dri/card-nvidia"
      KERNEL=="card[0-9]*", SUBSYSTEM=="drm", DRIVERS=="amdgpu", SYMLINK+="dri/card-amd"
    '';
  };
}
