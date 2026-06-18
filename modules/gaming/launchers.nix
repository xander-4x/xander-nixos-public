{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # lutris
    heroic
    # bottles
    winetricks
    protontricks
    mangohud
  ];
}