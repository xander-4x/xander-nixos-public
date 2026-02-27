{
  config,
  lib,
  pkgs,
  ...
}: {
  # Use zram for swap - fast, in-memory, compressed
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50; # Back to 50% since no disk swapfile
  };

  # No swapfile - using only zram
  swapDevices = [];
}
