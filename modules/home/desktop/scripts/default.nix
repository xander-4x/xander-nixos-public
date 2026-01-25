{
  pkgs,
  username,
  ...
}: {
  home.packages = [
    (import ./task-waybar.nix {inherit pkgs;})
    (import ./squirtle.nix {inherit pkgs;})
    (import ./nvidia-offload.nix {inherit pkgs;})
    (import ./wallsetter.nix {
      inherit pkgs;
      inherit username;
    })
    (import ./rofi-launcher.nix {inherit pkgs;})
    (import ./screenshootin.nix {inherit pkgs;})
  ];
}
