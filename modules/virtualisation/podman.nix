{pkgs, ...}: {
  virtualisation = {
    docker.enable = false;

    podman = {
      enable = true;
      dockerCompat = true;
      dockerSocket.enable = true;
      defaultNetwork.settings = {
        dns_enabled = true;
        subnet = "10.89.0.0/16";
        gateway = "10.89.0.1";
      };
    };
  };

  # Auto-restart podman containers on boot
  systemd.services.podman-restart = {
    description = "Podman Start All Containers With Restart Policy Set To Always";
    after = ["podman.socket" "network-online.target"];
    requires = ["podman.socket"];
    wants = ["network-online.target"];
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      Type = "oneshot";
      ExecStartPre = "${pkgs.coreutils}/bin/sleep 2";
      ExecStart = "${pkgs.podman}/bin/podman start --all --filter restart-policy=always";
      RemainAfterExit = true;
    };
  };

  environment.systemPackages = with pkgs; [
    podman-compose
    docker-compose
  ];
}
