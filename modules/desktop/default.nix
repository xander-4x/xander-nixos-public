{
  inputs,
  pkgs,
  host,
  ...
}:
let
  inherit (import ../../hosts/${host}/variables.nix) thunarEnable printEnable;
in
{
  imports = [
    ./boot.nix
    ./hardware.nix
    ./network.nix
    # ./pavucontrol.nix
    ./services.nix
    ./ssh-agent.nix
    ./tlp.nix
    ./xserver.nix
    ./audio.nix
    ./bluetooth.nix
    ./flatpak.nix
    ./fonts.nix
    ./greetd.nix
    ./stylix.nix
    ./easyeffects.nix
    ./pwvucontrol.nix
    ./ratbag.nix
    ./rustdesk.nix
    ./swaylock.nix
    inputs.stylix.nixosModules.stylix
  ]
  ++ (if thunarEnable then [ ./thunar.nix ] else [ ])
  ++ (if printEnable then [ ./printing.nix ] else [ ]);
}
