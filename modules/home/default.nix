# Full home-manager configuration (core + desktop)
# For server use, import only ./core
{...}: {
  imports = [
    ./core
    ./desktop
  ];
}
