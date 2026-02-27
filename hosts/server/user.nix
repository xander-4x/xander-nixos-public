{
  pkgs,
  inputs,
  username,
  host,
  ...
}: let
  inherit (import ./variables.nix) gitUsername;
in {
  imports = [inputs.home-manager.nixosModules.home-manager];

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = false;
    backupFileExtension = "backup";
    extraSpecialArgs = {inherit inputs username host;};
    users.${username} = {
      imports = [
        ../../modules/home/core # CLI only (no desktop)
        inputs.nixvim.homeModules.nixvim
      ];
      systemd.user.startServices = true;

      # Auto-restart rootless podman containers on boot
      systemd.user.services.podman-restart = {
        Unit = {
          Description = "Podman Start All Containers With Restart Policy";
          After = ["network-online.target"];
          Wants = ["network-online.target"];
        };
        Service = {
          Type = "oneshot";
          ExecStartPre = "${pkgs.coreutils}/bin/sleep 3";
          ExecStart = "${pkgs.podman}/bin/podman start --all --filter restart-policy=always";
          RemainAfterExit = true;
        };
        Install = {
          WantedBy = ["default.target"];
        };
      };
      nixpkgs.config.allowUnfree = true;

      home = {
        username = "${username}";
        homeDirectory = "/home/${username}";
        stateVersion = "25.11";
        sessionVariables = {
          DOCKER_HOST = "unix:///run/user/1000/podman/podman.sock";
        };
      };
      programs.home-manager.enable = true;
    };
  };

  users.mutableUsers = true;
  users.users.${username} = {
    isNormalUser = true;
    description = "${gitUsername}";
    extraGroups = ["wheel"];
    shell = pkgs.zsh;
    ignoreShellProgramCheck = true;
    linger = true; # Enable user services without login (for rootless podman)
    openssh.authorizedKeys.keys = [
      # Add your public SSH key here
      # "ssh-ed25519 AAAA... user@host"
    ];
  };

  # Root configuration
  users.users.root = {
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      # Add your public SSH key here
      # "ssh-ed25519 AAAA... user@host"
    ];
  };

  nix.settings.allowed-users = ["${username}"];
}
