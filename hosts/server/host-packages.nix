{ pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    claude-code
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
    screen
  ];
}
