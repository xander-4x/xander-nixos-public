{
  lib,
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
        # CLI core: zsh, git, nixvim, yazi, starship, fastfetch, gh, htop, btop, bat, zoxide.
        ../../modules/home/core
        inputs.nixvim.homeModules.nixvim

        # Non-Hyprland desktop bits — keep the laptop UX in Plasma's Desktop Mode.
        # Skipped: gtk.nix (Plasma owns GTK theming), xdg.nix (Hyprland portals),
        # stylix.nix (Plasma owns theming), virtmanager.nix (no libvirt),
        # waybar/rofi/dms/swaync/wlogout/awww/scripts/hyprland (Hyprland-only).
        ../../modules/home/desktop/wezterm.nix
        ../../modules/home/desktop/dev
        ../../modules/home/desktop/cava.nix
        ../../modules/home/desktop/cliphist.nix
        ../../modules/home/desktop/swappy.nix
        ../../modules/home/desktop/appimages.nix
        ../../modules/home/desktop/qt.nix
        ./plasma-session.nix
      ];
      systemd.user.startServices = true;

      nixpkgs.config.allowUnfree = true;

      home = {
        username = "${username}";
        homeDirectory = "/home/${username}";
        stateVersion = "25.11";
      };
      programs.home-manager.enable = true;

      # Van Gogh APU: no NVIDIA/CUDA, rocm causes wrong GPU temps on this APU
      programs.btop.package = lib.mkForce pkgs.btop;
      # Van Gogh APU: k10temp doesn't expose hwmon, use amdgpu edge as CPU temp
      programs.btop.settings.cpu_sensor = lib.mkForce "amdgpu edge";
    };
  };

  users.mutableUsers = true;
  users.users.${username} = {
    isNormalUser = true;
    description = "${gitUsername}";
    extraGroups = [
      "input"
      "networkmanager"
      "video"
      "wheel"
    ];
    shell = pkgs.zsh;
    ignoreShellProgramCheck = true;
  };
  nix.settings.allowed-users = [ "${username}" ];
}
