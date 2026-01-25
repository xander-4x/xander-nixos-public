{pkgs, ...}: {
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    htop
    btop
    git
    eza
    ripgrep
    ncdu
    duf
  ];
}
