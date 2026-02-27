{...}: {
  imports = [
    ./boot.nix
    ./network.nix
    ./services.nix
  ];

  # Enable zsh system-wide
  programs.zsh.enable = true;

  # SSH agent for server (no GNOME Keyring here)
  programs.ssh.startAgent = true;
}
