{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [ easyeffects ];

  # Enable EasyEffects service for users
  systemd.user.services.easyeffects = {
    description = "EasyEffects audio processing";
    after = [
      "graphical-session.target"
      "pipewire.service"
      "wireplumber.service"
    ];
    wants = [
      "pipewire.service"
      "wireplumber.service"
    ];
    wantedBy = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.easyeffects}/bin/easyeffects --gapplication-service";
      Restart = "on-failure";
      RestartSec = 3;
    };
  };
}
