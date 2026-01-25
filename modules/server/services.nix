{...}: {
  services = {
    # SSH with hardened settings
    openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "prohibit-password";
        PasswordAuthentication = false;
      };
    };

    # SSD optimization
    fstrim.enable = true;

    # Tailscale VPN
    tailscale.enable = true;
  };
}
