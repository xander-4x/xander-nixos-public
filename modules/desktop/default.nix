{
  inputs,
  pkgs,
  host,
  ...
}:
let
  inherit (import ../../hosts/${host}/variables.nix) thunarEnable printEnable shellChoice;

  # Stylix imports (disabled when using DMS - it handles theming via matugen)
  stylixImports =
    if shellChoice == "dms" then
      [ ]
    else
      [
        ./stylix.nix
        inputs.stylix.nixosModules.stylix
      ];
in
{
  imports = [
    ./boot.nix
    ./hardware.nix
    ./network.nix
    ./services.nix
    ./ssh-agent.nix
    ./tlp.nix
    ./xserver.nix
    ./audio.nix
    ./bluetooth.nix
    # ./flatpak.nix
    ./fonts.nix
    ./greetd.nix
    ./easyeffects.nix
    ./pwvucontrol.nix
    ./ratbag.nix
    ./anydesk.nix
    ./swaylock.nix
  ]
  ++ stylixImports
  ++ (if thunarEnable then [ ./thunar.nix ] else [ ])
  ++ (if printEnable then [ ./printing.nix ] else [ ]);
}
