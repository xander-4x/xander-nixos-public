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
        ../../modules/home # Imports both core and desktop
        inputs.nixvim.homeModules.nixvim
      ];
      systemd.user.startServices = true;

      nixpkgs.config.allowUnfree = true;

      # Auto-resolve conflicts by overwriting backup files
      home.activation.removeBackups = {
        after = [];
        before = ["checkLinkTargets"];
        data = ''
          find $HOME -name "*.backup" -type f -delete 2>/dev/null || true
        '';
      };

      home = {
        username = "${username}";
        homeDirectory = "/home/${username}";
        stateVersion = "24.11";
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
    extraGroups = [
      "adbusers"
      "libvirtd"
      "lp"
      "networkmanager"
      "scanner"
      "wheel"
    ];
    shell = pkgs.zsh;
    ignoreShellProgramCheck = true;
    linger = true; # Enable user services without login (for rootless podman)
  };
  nix.settings.allowed-users = ["${username}"];
}
