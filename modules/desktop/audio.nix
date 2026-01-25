{...}: {
  # Audio services for desktop
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true; # WebRTC support
  };

  # Required for real-time audio processing
  security.rtkit.enable = true;
}
