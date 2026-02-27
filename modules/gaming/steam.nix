{pkgs, config, ...}: {
  programs = {
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = false;
      gamescopeSession.enable = true;
      extraCompatPackages = [pkgs.proton-ge-bin pkgs.vkd3d-proton];
    };

    gamescope = {
      enable = true;
      capSysNice = true;
      args = [
        "--rt"
        "--expose-wayland"
      ];
    };
  };

  # Steam-specific environment variables (non-GPU related)
  environment.sessionVariables = {
    ENABLE_VK_LAYER_VALVE_steam_overlay = "0";
    ENABLE_VK_LAYER_VALVE_steam_fossilize = "0";
    DXVK_LOG_LEVEL = "warn";
    WINEDEBUG = "-all";
    TZ = config.time.timeZone;
  };

  # For NVIDIA gaming, use: nvidia-offload steam
  # This prevents battery drain when not gaming
}
