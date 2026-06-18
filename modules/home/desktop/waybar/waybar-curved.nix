{
  pkgs,
  lib,
  host,
  config,
  ...
}:
let
  betterTransition = "all 0.3s cubic-bezier(.55,-0.68,.48,1.682)";
  inherit (import ../../../../hosts/${host}/variables.nix) clock24h terminal;
in
with lib;
{
  # Configure & Theme Waybar
  programs.waybar = let
    powerProfileStatus = pkgs.writeShellScript "power-profile-status" ''
      PROFILE=$(cat /sys/firmware/acpi/platform_profile 2>/dev/null || echo "unknown")
      case "$PROFILE" in
        low-power)   printf '{"text":"󰌪 quiet","class":"low-power","tooltip":"Power: Quiet — click for Balanced"}' ;;
        balanced)    printf '{"text":"󰾅 balanced","class":"balanced","tooltip":"Power: Balanced — click for Performance"}' ;;
        performance) printf '{"text":"󱑴 perf","class":"performance","tooltip":"Power: Performance — click for Quiet"}' ;;
        *)           printf '{"text":"? power","class":"unknown","tooltip":"Power: Unknown"}' ;;
      esac
    '';
    batteryLimitStatus = pkgs.writeShellScript "battery-limit-status" ''
      THRESHOLD=$(cat /sys/class/power_supply/BAT0/charge_control_end_threshold 2>/dev/null || echo 100)
      if [ "$THRESHOLD" -le 80 ]; then
        printf '{"text":"󰂌 80%%","class":"limited","tooltip":"Battery limit: 80%% (click to disable)"}'
      else
        printf '{"text":"󰂄 ∞","class":"unlimited","tooltip":"Battery limit: off (click to enable 80%%)"}'
      fi
    '';
  in {
    enable = true;
    package = pkgs.waybar;
    systemd.enable = true;
    systemd.targets = [ "graphical-session.target" ];
    settings = [
      {
        layer = "top";
        position = "top";
        modules-center = [ "clock" ];
        modules-left = [
          "custom/startmenu"
          "hyprland/workspaces"
          "pulseaudio"
          "backlight"
          "idle_inhibitor"
          "hyprland/window"
        ];
        modules-right = [
          "cpu"
          "memory"
          "custom/power-profile"
          "custom/battery-limit"
          "custom/notification"
          "hyprland/language"
          "tray"
          "battery"
          "custom/exit"
        ];

        "hyprland/workspaces" = {
          format = "{name}";
          format-icons = {
            default = " ";
            active = " ";
            urgent = " ";
          };
          on-scroll-up = "hyprctl dispatch workspace e+1";
          on-scroll-down = "hyprctl dispatch workspace e-1";
        };
        "hyprland/language" = {
          format = "{short}";
        };
        "clock" = {
          format = if clock24h == true then " {:L%H:%M}" else " {:L%I:%M %p}";
          tooltip = true;
          tooltip-format = "<big>{:%A, %d.%B %Y }</big>\n<tt><small>{calendar}</small></tt>";
        };
        "hyprland/window" = {
          max-length = 22;
          separate-outputs = false;
          rewrite = {
            "" = " Empty ";
          };
        };
        "memory" = {
          interval = 5;
          format = " {}%";
          tooltip = true;
          on-click = "${terminal} -e btop";
        };
        "cpu" = {
          interval = 5;
          format = " {usage:2}%";
          tooltip = true;
          on-click = "${terminal} -e btop";
        };
        "disk" = {
          format = " {free}";
          tooltip = true;
        };
        "network" = {
          format-icons = [
            "󰤯"
            "󰤟"
            "󰤢"
            "󰤥"
            "󰤨"
          ];
          format-ethernet = " {bandwidthDownOctets}";
          format-wifi = "{icon} {signalStrength}%";
          format-disconnected = "󰤮";
          tooltip = false;
        };
        "tray" = {
          spacing = 12;
        };
        "backlight" = {
          format = "{icon} {percent}%";
          format-icons = [ "󰃞" "󰃟" "󰃠" ];
          tooltip = true;
          tooltip-format = "Brightness: {percent}%";
          on-scroll-up = "brightnessctl set +5%";
          on-scroll-down = "brightnessctl set 5%-";
        };
        "pulseaudio" = {
          format = "{icon} {volume}% {format_source}";
          format-bluetooth = "{volume}% {icon} {format_source}";
          format-bluetooth-muted = " {icon} {format_source}";
          format-muted = " {format_source}";
          format-source = " {volume}%";
          format-source-muted = "";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = [
              ""
              ""
              ""
            ];
          };
          on-click = "sleep 0.1 && /run/current-system/sw/bin/pwvucontrol";
        };
        "custom/exit" = {
          tooltip = false;
          format = "";
          on-click = "sleep 0.1 && wlogout";
        };
        "custom/startmenu" = {
          tooltip = false;
          format = "";
          # exec = "rofi -show drun";
          on-click = "sleep 0.1 && rofi-launcher";
        };
        "idle_inhibitor" = {
          format = "{icon}";
          format-icons = {
            activated = "  ";
            deactivated = "  ";
          };
          tooltip = "true";
        };
        "custom/notification" = {
          tooltip = false;
          format = "{icon} {text}";
          format-icons = {
            notification = "<span foreground='red'><sup></sup></span>";
            none = "";
            dnd-notification = "<span foreground='red'><sup></sup></span>";
            dnd-none = "";
            inhibited-notification = "<span foreground='red'><sup></sup></span>";
            inhibited-none = "";
            dnd-inhibited-notification = "<span foreground='red'><sup></sup></span>";
            dnd-inhibited-none = "";
          };
          return-type = "json";
          exec-if = "which swaync-client";
          exec = "swaync-client -swb";
          on-click = "sleep 0.1 && task-waybar";
          escape = true;
        };
        "custom/power-profile" = {
          exec = "${powerProfileStatus}";
          return-type = "json";
          interval = 2;
          on-click = "/run/current-system/sw/bin/power-profile-toggle";
          tooltip = true;
        };
        "custom/battery-limit" = {
          exec = "${batteryLimitStatus}";
          return-type = "json";
          interval = 5;
          on-click = "/run/current-system/sw/bin/battery-limit-toggle";
          tooltip = true;
        };
        "battery" = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-charging = "󰂄 {capacity}%";
          format-plugged = "󱘖 {capacity}%";
          format-icons = [
            "󰁺"
            "󰁻"
            "󰁼"
            "󰁽"
            "󰁾"
            "󰁿"
            "󰂀"
            "󰂁"
            "󰂂"
            "󰁹"
          ];
          on-click = "";
          tooltip = false;
        };
      }
    ];
    style = concatStrings [
      ''
        * {
          font-family: JetBrainsMono Nerd Font Mono;
          font-size: 14px;
          border-radius: 0px;
          border: none;
          min-height: 0px;
        }
        window#waybar {
          background: rgba(0,0,0,0);
        }
        #workspaces {
          color: #${config.lib.stylix.colors.base00};
          background: #${config.lib.stylix.colors.base01};
          margin: 4px 4px;
          padding: 5px 5px;
          border-radius: 16px;
        }
        #workspaces button {
          font-weight: bold;
          padding: 0px 5px;
          margin: 0px 3px;
          border-radius: 16px;
          color: #${config.lib.stylix.colors.base00};
          background: linear-gradient(45deg, #${config.lib.stylix.colors.base08}, #${config.lib.stylix.colors.base0D});
          opacity: 0.5;
          transition: ${betterTransition};
        }
        #workspaces button.active {
          font-weight: bold;
          padding: 0px 5px;
          margin: 0px 3px;
          border-radius: 16px;
          color: #${config.lib.stylix.colors.base00};
          background: linear-gradient(45deg, #${config.lib.stylix.colors.base08}, #${config.lib.stylix.colors.base0D});
          transition: ${betterTransition};
          opacity: 1.0;
          min-width: 40px;
        }
        #workspaces button:hover {
          font-weight: bold;
          border-radius: 16px;
          color: #${config.lib.stylix.colors.base00};
          background: linear-gradient(45deg, #${config.lib.stylix.colors.base08}, #${config.lib.stylix.colors.base0D});
          opacity: 0.8;
          transition: ${betterTransition};
        }
        tooltip {
          background: #${config.lib.stylix.colors.base00};
          border: 1px solid #${config.lib.stylix.colors.base08};
          border-radius: 12px;
        }
        tooltip label {
          color: #${config.lib.stylix.colors.base08};
        }
        #window, #pulseaudio, #backlight, #idle_inhibitor {
          font-weight: bold;
          margin: 4px 0px;
          margin-left: 7px;
          padding: 0px 18px;
          background: #${config.lib.stylix.colors.base04};
          color: #${config.lib.stylix.colors.base05};
          border-radius: 24px 10px 24px 10px;
        }
        #custom-startmenu {
          color: #${config.lib.stylix.colors.base0B};
          background: #${config.lib.stylix.colors.base02};
          font-size: 28px;
          margin: 0px;
          padding: 0px 20px 0px 10px;
          border-radius: 0px 0px 40px 0px;
        }
        #custom-hyprbindings, #network, #battery,
        #custom-notification, #tray, #language, #custom-exit, #cpu, #memory,
        #custom-power-profile, #custom-battery-limit {
          font-weight: bold;
          background: #${config.lib.stylix.colors.base0F};
          color: #${config.lib.stylix.colors.base00};
          margin: 4px 0px;
          margin-right: 7px;
          border-radius: 10px 24px 10px 24px;
          padding: 0px 18px;
        }
        #custom-power-profile.low-power {
          background: #${config.lib.stylix.colors.base0B};
        }
        #custom-power-profile.performance {
          background: #${config.lib.stylix.colors.base08};
        }
        #custom-battery-limit.limited {
          background: #${config.lib.stylix.colors.base0B};
        }
        #clock {
          color: #${config.lib.stylix.colors.base05};
          background: #${config.lib.stylix.colors.base01};
          margin: 4px 4px;
          padding: 5px 10px;
          border-radius: 16px;
        }
        #custom-exit {
          font-weight: bold;
          color: #0D0E15;
          background: linear-gradient(90deg, #${config.lib.stylix.colors.base0E}, #${config.lib.stylix.colors.base0C});
          margin: 0px;
          padding: 0px 10px 0px 20px;
          border-radius: 0px 0px 0px 40px;
        }
      ''
    ];
  };
}
