{...}: {
  # Intel Core 7 240H (Raptor Lake-P), Intel Iris Xe iGPU, Intel CNVi WiFi.
  boot.kernelParams = [
    "iommu=pt"

    # i915 power saving on idle (built-in panel has no PSR/Panel Replay support)
    "i915.enable_fbc=1" # Framebuffer compression — memory bandwidth saving
    "i915.enable_guc=2" # GuC submission + HuC firmware loading
  ];
}
