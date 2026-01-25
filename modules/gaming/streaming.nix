# modules/system/streaming.nix
{ config,
pkgs,
lib,
username,
  ...
}: let
  cameraVid = "046d";
  cameraPid = "08e5";
in {
  #### Пакеты для стриминга и работы с камерой
  environment.systemPackages = with pkgs; [
    v4l-utils
    obs-studio
    easyeffects
  ];

  users.users.${username}.extraGroups = [ "video" ];

  systemd.services."webcam-autoset" = {
    description = "Auto configure Logitech C920 PRO HD webcam";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "webcam-autoset.sh" ''
        log() { echo "[webcam-autoset] $1"; }

        for dev in /dev/video*; do
          if udevadm info --query=all --name="$dev" | grep -q "ID_VENDOR_ID=${cameraVid}"; then
            if udevadm info --query=all --name="$dev" | grep -q "ID_MODEL_ID=${cameraPid}"; then
              CAM="$dev"
              break
            fi
          fi
        done

        if [ -z "$CAM" ]; then
          log "Logitech C920 PRO HD Camera Not Found."
          exit 0
        fi

        log "Camera found: $CAM"
        sleep 1

        v4l2-ctl -d "$CAM" --set-ctrl=brightness=128
        v4l2-ctl -d "$CAM" --set-ctrl=contrast=128
        v4l2-ctl -d "$CAM" --set-ctrl=saturation=128
        v4l2-ctl -d "$CAM" --set-ctrl=focus_auto=0
        v4l2-ctl -d "$CAM" --set-ctrl=focus_absolute=20
        v4l2-ctl -d "$CAM" --set-ctrl=exposure_auto=1
        v4l2-ctl -d "$CAM" --set-ctrl=exposure_absolute=200
        v4l2-ctl -d "$CAM" --set-ctrl=white_balance_temperature_auto=0
        v4l2-ctl -d "$CAM" --set-ctrl=white_balance_temperature=4500
        v4l2-ctl -d "$CAM" --set-ctrl=zoom_absolute=120

        log "Settings applied successfully."
      '';
    };
  };

  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="video4linux", ATTRS{idVendor}=="${cameraVid}", ATTRS{idProduct}=="${cameraPid}", TAG+="systemd", ENV{SYSTEMD_WANTS}+="webcam-autoset.service"
  '';
}
