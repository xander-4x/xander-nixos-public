{
  pkgs,
  options,
  ...
}:
{
  # Desktop network configuration
  # Note: hostname is set in modules/core/system.nix

  networking = {
    networkmanager.enable = true;
    timeServers = options.networking.timeServers.default ++ [ "pool.ntp.org" ];
    extraHosts = ''
      x.x.x.x localdomain.test
    '';
    firewall = {
      enable = true;
      allowedTCPPorts = [
        22
        80
        443
        59010
        59011
        8080
        57621
      ];
      allowedUDPPorts = [
        59010
        59011
        5353
      ];
    };
  };

  environment.systemPackages = with pkgs; [ networkmanagerapplet ];
}
