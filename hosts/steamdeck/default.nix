{username, ...}: let
  inherit (import ./variables.nix) autoStart desktopSession enableDeckyLoader;
in {
  imports = [
    # Host-specific
    ./hardware.nix
    ./host-packages.nix
    ./user.nix
    ./zram.nix

    # Core system modules (system, security, nh, syncthing, nfs, starfish)
    ../../modules/core

    # Cherry-picked desktop bits (full modules/desktop pulls Hyprland/greetd/Stylix)
    ../../modules/desktop/bluetooth.nix
    ../../modules/desktop/fonts.nix
    ../../modules/desktop/plasma.nix

    # Gaming: Jovian Steam Deck stack (audio/kernel/fan/perf/session) + extra launchers
    ../../modules/gaming/jovian.nix
    ../../modules/gaming/launchers.nix

    # AMD APU support (rocm tmpfiles)
    ../../modules/drivers/amd-drivers.nix
  ];

  # Bootloader (modules/desktop/boot.nix isn't imported — it has laptop-specific quirks)
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };
  boot.plymouth.enable = true;

  # Networking — flat NetworkManager + standard firewall
  networking = {
    networkmanager.enable = true;
    firewall.enable = true;
  };

  # Input handling for keyboards / external controllers (separate from Steam Input)
  services.libinput.enable = true;
  services.fstrim.enable = true;

  # Drivers
  drivers.amdgpu.enable = true;

  # SSH agent via gnome-keyring (PAM sets SSH_AUTH_SOCK automatically)
  services.gnome.gnome-keyring.enable = true;

  # Desktop
  desktop.plasma.enable = true;

  # Gaming Mode
  gaming.jovian = {
    enable = true;
    user = username;
    inherit autoStart desktopSession;
    deckyLoader.enable = enableDeckyLoader;
  };

  system.stateVersion = "25.11";
}
