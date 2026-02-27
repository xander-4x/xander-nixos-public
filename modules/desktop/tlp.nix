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

        # Disable CPU management
        CPU_SCALING_GOVERNOR_ON_AC = "";
        CPU_SCALING_GOVERNOR_ON_BAT = "";
        CPU_ENERGY_PERF_POLICY_ON_AC = "";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "";
      };
    };
  };
}
