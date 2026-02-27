{...}: {
  # Use zram for swap - fast, in-memory, compressed
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 25;
  };

  # No swapfile - using only zram
  swapDevices = [];
}
