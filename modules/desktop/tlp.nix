{
  config,
  lib,
  pkgs,
  ...
}:

{
  config = {
    services.tlp = {
      enable = true;

      settings = {
        # Runtime PM for devices
        RUNTIME_PM_ON_AC = "auto";
        RUNTIME_PM_ON_BAT = "auto";

        # USB/PCIe power management
        USB_AUTOSUSPEND = "1";
        PCIE_ASPM_ON_BAT = "powersupersave";

        PLATFORM_PROFILE_ON_AC = "balanced";
        PLATFORM_PROFILE_ON_BAT = "low-power";

        # intel_pstate/amd_pstate in active mode always use "powersave" governor;
        # actual policy is driven by Energy Performance Preference (EPP).
        # Values mirror what the ThinkPad firmware sets via platform_profile.
        CPU_SCALING_GOVERNOR_ON_AC = "powersave";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
        CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";

        # Turbo boost off on battery — large package power drop on bursts
        CPU_BOOST_ON_AC = 1;
        CPU_BOOST_ON_BAT = 0;

        # Wi-Fi power save on battery
        WIFI_PWR_ON_BAT = "on";

        # Wake-on-LAN off (powertop flagged it enabled)
        WOL_DISABLE = "Y";

        # Audio codec autosuspend
        SOUND_POWER_SAVE_ON_BAT = 1;
        SOUND_POWER_SAVE_CONTROLLER = "Y";

        # NMI watchdog off — small power saving, not useful on a laptop
        NMI_WATCHDOG = 0;
      };
    };
  };
}
