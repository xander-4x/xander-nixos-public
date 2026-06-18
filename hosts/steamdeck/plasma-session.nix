{
  lib,
  pkgs,
  ...
}: {
  # Disable KWallet — kded6 respects this config and won't start kwalletd.
  xdg.configFile."kwalletrc".text = ''
    [Wallet]
    Enabled=false
    First Use=false
  '';

  # KWin virtual keyboard: plasma-keyboard via Wayland input-method-v1.
  # Set via kwriteconfig6 (not symlinked) because KWin updates kwinrc at runtime.
  # Why: Steam OSK injects via XTest which Wayland blocks; KDE-native OSK uses
  # input-method-v1, appears on touch focus by default (no click trigger needed).
  # KWin requires the full path to the .desktop file, not just the basename.
  home.activation.setKwinVirtualKeyboard = lib.hm.dag.entryAfter ["writeBoundary"] ''
    run ${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 \
      --file kwinrc \
      --group Wayland \
      --key InputMethod /run/current-system/sw/share/applications/org.kde.plasma.keyboard.desktop
  '';

  # Auto-start Steam in Desktop Mode for the Steam Input controller overlay.
  xdg.configFile."autostart/steam.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=Steam
    Exec=steam -silent %U
    Icon=steam
    Terminal=false
    Categories=Network;FileTransfer;Game;
    X-KDE-AutostartScript=true
  '';
}
