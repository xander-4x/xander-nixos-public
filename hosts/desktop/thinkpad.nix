{ pkgs, username, ... }:
let
  powerProfileToggle = pkgs.writeShellScriptBin "power-profile-toggle" ''
    PROFILE=$(cat /sys/firmware/acpi/platform_profile)
    case "$PROFILE" in
      low-power)   NEXT="balanced" ;;
      balanced)    NEXT="performance" ;;
      *)           NEXT="low-power" ;;
    esac
    echo "$NEXT" > /sys/firmware/acpi/platform_profile
  '';

  batteryLimitToggle = pkgs.writeShellScriptBin "battery-limit-toggle" ''
    STATE=/var/lib/battery-charge-limit
    THRESHOLD=$(cat /sys/class/power_supply/BAT0/charge_control_end_threshold 2>/dev/null || echo 100)
    if [ "$THRESHOLD" -le 80 ]; then
      echo 100 > /sys/class/power_supply/BAT0/charge_control_end_threshold
      echo 95  > /sys/class/power_supply/BAT0/charge_control_start_threshold
      echo "100" > "$STATE"
    else
      echo 75  > /sys/class/power_supply/BAT0/charge_control_start_threshold
      echo 80  > /sys/class/power_supply/BAT0/charge_control_end_threshold
      echo "80" > "$STATE"
    fi
  '';

  brightnessOnBat = pkgs.writeShellScript "brightness-on-battery" ''
    BL=/sys/class/backlight/intel_backlight
    MAX=$(cat $BL/max_brightness)
    echo $((MAX / 2)) > $BL/brightness
  '';

  brightnessOnAc = pkgs.writeShellScript "brightness-on-ac" ''
    BL=/sys/class/backlight/intel_backlight
    cat $BL/max_brightness > $BL/brightness
  '';
in
{
  environment.systemPackages = [ powerProfileToggle batteryLimitToggle ];

  # Intel thermal daemon — keeps CPU in correct P/C-states under light load.
  # Complements TLP, does not conflict.
  services.thermald.enable = true;

  # Auto-adjust backlight on AC/battery transitions
  services.udev.extraRules = ''
    SUBSYSTEM=="power_supply", ATTR{type}=="Mains", ATTR{online}=="0", RUN+="${brightnessOnBat}"
    SUBSYSTEM=="power_supply", ATTR{type}=="Mains", ATTR{online}=="1", RUN+="${brightnessOnAc}"
  '';

  # Allow user to write power management sysfs nodes without root
  systemd.services.thinkpad-sysfs-perms = {
    description = "Set write permissions on ThinkPad power sysfs nodes";
    wantedBy = [ "multi-user.target" ];
    after = [ "systemd-udev-settle.service" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "set-thinkpad-perms" ''
        chmod 0666 /sys/firmware/acpi/platform_profile || true
        chmod 0666 /sys/class/power_supply/BAT0/charge_control_end_threshold || true
        chmod 0666 /sys/class/power_supply/BAT0/charge_control_start_threshold || true
      '';
    };
  };

  # Restore battery charge limit on boot
  systemd.services.battery-charge-limit = {
    description = "Restore battery charge limit";
    wantedBy = [ "multi-user.target" ];
    after = [ "systemd-udev-settle.service" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "apply-battery-limit" ''
        STATE=/var/lib/battery-charge-limit
        [ -f "$STATE" ] || exit 0
        LIMIT=$(cat "$STATE")
        if [ "$LIMIT" = "80" ]; then
          echo 75 > /sys/class/power_supply/BAT0/charge_control_start_threshold
          echo 80 > /sys/class/power_supply/BAT0/charge_control_end_threshold
        fi
      '';
    };
  };
}
