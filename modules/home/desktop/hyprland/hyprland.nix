{
  host,
  config,
  pkgs,
  ...
}: let
  inherit
    (import ../../../../hosts/${host}/variables.nix)
    keyboardLayout
    extraMonitorSettings
    shellChoice
    ;

  # Shell-specific startup commands (DMS uses systemd service instead)
  shellExecOnce = if shellChoice == "dms" then [
  ] else [
    "killall -q waybar;sleep .5 && waybar"
    "killall -q swaync;sleep .5 && swaync"
  ];
in {
  home.packages = with pkgs; [
    swww
    grim
    slurp
    wl-clipboard
    swappy
    ydotool
    hyprpolkitagent
    hyprland-qtutils # needed for banners and ANR messages
  ];
  systemd.user.targets.hyprland-session.Unit.Wants = [
    "xdg-desktop-autostart.target"
  ];
  # Place Files Inside Home Directory
  home.file = {
    "Pictures/Wallpapers" = {
      source = ../../../../wallpapers;
      recursive = true;
    };
    ".face.icon".source = ./avatar.png;
    ".config/avatar.png".source = ./avatar.png;
  };
  wayland.windowManager.hyprland = {
    enable = true;
    package = pkgs.hyprland;
    systemd = {
      enable = true;
      enableXdgAutostart = true;
      variables = ["--all"];
    };
    xwayland = {
      enable = true;
    };

    # Source DMS-generated configs (when using DMS)
    extraConfig = if shellChoice == "dms" then ''
      source = ~/.config/hypr/dms/colors.conf
      source = ~/.config/hypr/dms/cursor.conf
      source = ~/.config/hypr/dms/outputs.conf
    '' else "";

    settings = {
      "$modifier" = "SUPER";

      exec-once = [
        "dbus-update-activation-environment --all --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "systemctl --user start hyprpolkitagent"
        "nm-applet --indicator"
        "pypr &"
      ] ++ shellExecOnce;

      input = {
        kb_layout = "${keyboardLayout}";
        kb_options = [
          "grp:alt_shift_toggle"
        ];
        numlock_by_default = true;
        repeat_delay = 300;
        follow_mouse = 1;
        float_switch_override_focus = 0;
        sensitivity = 0;
        resolve_binds_by_sym = true;  # Помогает с правильной обработкой клавиш
        touchpad = {
          natural_scroll = true;
          disable_while_typing = true;
          scroll_factor = 0.6;
        };
      };

      gesture = [
        "3, horizontal, workspace"
      ];

      general = {
        layout = "dwindle";
        gaps_in = 6;
        gaps_out = 8;
        border_size = 2;
        resize_on_border = true;
      } // (if shellChoice == "dms" then {
        # Border colors managed by DMS via colors.conf
      } else {
        "col.active_border" = "rgb(${config.lib.stylix.colors.base08}) rgb(${config.lib.stylix.colors.base0C}) 45deg";
        "col.inactive_border" = "rgb(${config.lib.stylix.colors.base01})";
      });

      misc = {
        layers_hog_keyboard_focus = true;
        initial_workspace_tracking = 0;
        mouse_move_enables_dpms = true;
        key_press_enables_dpms = false;
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        enable_swallow = false;
        vfr = true; # Variable Frame Rate
        vrr = 0; #Variable Refresh Rate  Set to 0 for NVIDIA/AQ_DRM_DEVICES
        # Screen flashing to black momentarily or going black when app is fullscreen
        # Try setting vrr to 0
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      decoration = {
        rounding = 10;
        blur = {
          enabled = true;
          size = 5;
          passes = 3;
          ignore_opacity = false;
          new_optimizations = true;
        };
        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
          color = "rgba(1a1a1aee)";
        };
      };

      cursor = {
        sync_gsettings_theme = true;
        no_hardware_cursors = 2; # change to 1 if want to disable
        enable_hyprcursor = false;
        warp_on_change_workspace = 2;
        no_warps = true;
      };

      master = {
        new_status = "master";
        new_on_top = 1;
        mfact = 0.5;
      };
    };
  };
}

