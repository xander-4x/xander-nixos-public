{
  pkgs,
  inputs,
  username,
  host,
  ...
}:
let
  inherit (import ./variables.nix) gitUsername;
in
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = false;
    backupFileExtension = "backup";
    extraSpecialArgs = { inherit inputs username host; };
    users.${username} = {
      imports = [
        ../../modules/home/core # CLI only (no desktop)
      ];
      systemd.user.startServices = true;
      nixpkgs.config.allowUnfree = true;

      home = {
        username = "${username}";
        homeDirectory = "/home/${username}";
        stateVersion = "25.11";
      };
      programs.home-manager.enable = true;
    };
  };

  users.mutableUsers = true;
  users.users.${username} = {
    isNormalUser = true;
    description = "${gitUsername}";
    extraGroups = [
      "wheel"
      "docker"
    ];
    shell = pkgs.zsh;
    ignoreShellProgramCheck = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 your-ssh-key"
    ];
  };

  # Root SSH access
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 your-ssh-key"
  ];

  nix.settings.allowed-users = [ "${username}" ];
}
