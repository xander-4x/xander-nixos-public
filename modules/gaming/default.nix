{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [
    ./launchers.nix
    ./steam.nix
    ./streaming.nix
  ];

  # NVIDIA gaming optimizations removed - use nvidia-offload command instead
  # This prevents all applications from using NVIDIA and draining battery

  environment.etc."xdg/applications/steam-nvidia.desktop".text = ''
    [Desktop Entry]
    Name=Steam (NVIDIA)
    Exec=nvidia-offload steam
    Icon=steam
    Type=Application
    Categories=Game;Application;
  '';

  environment.shellAliases.steam-nvidia = "nvidia-offload steam";
  environment.shellAliases.steam-gamescope = "nvidia-offload ${pkgs.gamescope}/bin/gamescope -f --rt --expose-wayland -- steam";
}
