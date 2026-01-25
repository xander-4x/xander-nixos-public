{host, ...}: {
  imports = [
    ./cloud-tools.nix
    ./go.nix
    ./nixvim
    # ./nvf.nix
    ./vscodium.nix
  ];
}
