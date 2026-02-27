{ pkgs, ... }:
{
  environment.systemPackages = [
    # AnyDesk wrapped to run via XWayland (fixes display issues on Wayland)
    (pkgs.symlinkJoin {
      name = "anydesk-xwayland";
      paths = [ pkgs.anydesk ];
      buildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/anydesk \
          --set GDK_BACKEND x11 \
          --prefix PATH : ${pkgs.inetutils}/bin
      '';
    })
  ];
}
