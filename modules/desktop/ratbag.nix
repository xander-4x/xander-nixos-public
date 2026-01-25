{ pkgs, ... }:

{
  services.ratbagd.enable = true;

  # Enable input-remapper service
  # services.input-remapper.enable = true;

  environment.systemPackages = with pkgs; [
    piper
    # input-remapper
  ];
}