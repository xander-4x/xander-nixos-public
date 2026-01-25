{ pkgs, ... }:
{
  environment.systemPackages = [
    # RustDesk wrapped to run via XWayland (fixes keyboard input on Wayland)
    (pkgs.symlinkJoin {
      name = "rustdesk-xwayland";
      paths = [ pkgs.rustdesk ];
      buildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/rustdesk \
          --set GDK_BACKEND x11
      '';
    })
  ];
}
