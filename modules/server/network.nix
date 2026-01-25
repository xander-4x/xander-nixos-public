{...}: {
  # Server network configuration
  # Note: hostname is set in modules/core/system.nix

  networking = {
    useDHCP = false;
    interfaces.eth0.useDHCP = true;

    firewall = {
      enable = true;
      allowedTCPPorts = [22];
    };
  };
}
