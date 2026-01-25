{...}: {
  imports = [
    ./hardware.nix
    ./host-packages.nix
    ./user.nix
    ./zram.nix

    # Core system modules (shared)
    ../../modules/core

    # Server-specific modules
    ../../modules/server
  ];

  system.stateVersion = "25.11";
}
