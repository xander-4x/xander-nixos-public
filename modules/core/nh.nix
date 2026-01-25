{
  pkgs,
  username,
  ...
}: {
  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      extraArgs = "--keep-since 3d --keep 5";
    };
    flake = "/home/${username}/nixos-config";
  };

  environment.systemPackages = with pkgs; [
    nix-output-monitor
    nvd
  ];
}
