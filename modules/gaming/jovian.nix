{
  lib,
  config,
  inputs,
  ...
}:
with lib;
let
  cfg = config.gaming.jovian;
in
{
  imports = [ inputs.jovian.nixosModules.default ];

  options.gaming.jovian = {
    enable = mkEnableOption "Enable Jovian-NixOS Steam Deck stack";

    user = mkOption {
      type = types.str;
      description = "User account that runs Steam in Gaming Mode.";
    };

    autoStart = mkOption {
      type = types.bool;
      default = true;
      description = "Boot directly into Gaming Mode (SDDM auto-login + gamescope-session).";
    };

    desktopSession = mkOption {
      type = types.nullOr types.str;
      default = "plasma";
      description = "Desktop session reachable from Gaming Mode's «Switch to Desktop». Set null to disable.";
    };

    deckyLoader.enable = mkEnableOption "Enable Decky Loader plugin host for the Steam UI";
  };

  config = mkIf cfg.enable {
    environment.sessionVariables = {
      TZ = config.time.timeZone;
    };

    jovian = {
      devices.steamdeck = {
        enable = true;
        enableGyroDsuService = true;
        autoUpdate = true;
      };

      steam = {
        enable = true;
        user = cfg.user;
        autoStart = cfg.autoStart;
        desktopSession = cfg.desktopSession;
      };

      steamos.useSteamOSConfig = true;

      decky-loader.enable = cfg.deckyLoader.enable;
    };
  };
}
