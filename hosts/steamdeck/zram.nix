{...}: {
  # zram swap for handheld. Jovian's steamos.useSteamOSConfig also enables zram with
  # these defaults; defining here keeps the per-host pattern consistent and explicit.
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;
  };

  swapDevices = [];
}
