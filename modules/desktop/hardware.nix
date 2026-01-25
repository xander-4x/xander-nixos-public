{pkgs, ...}: {
  hardware = {
    sane = {
      enable = true;
      extraBackends = [pkgs.sane-airscan];
      disabledDefaultBackends = ["escl"];
    };
    logitech.wireless.enable = false;
    logitech.wireless.enableGraphical = false;
    graphics = {
      enable = true;
      extraPackages = with pkgs; [libva-vdpau-driver libva];
    };
    enableRedistributableFirmware = true;
    keyboard.qmk.enable = true;
    # Bluetooth is now in modules/desktop/bluetooth.nix
  };
  local.hardware-clock.enable = false;
}
