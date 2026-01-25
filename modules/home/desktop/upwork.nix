{pkgs, ...}: let
  xdg-open-chromium = pkgs.writeShellScriptBin "xdg-open" ''
    # If URL starts with upwork://, pass it to the real upwork binary
    if [[ "$1" == upwork://* ]]; then
      exec ${pkgs.upwork}/bin/upwork "$@"
    else
      exec ${pkgs.chromium}/bin/chromium "$@"
    fi
  '';
in {
  home.packages = [
    (pkgs.upwork.overrideAttrs (oldAttrs: {
      postInstall =
        (oldAttrs.postInstall or "")
        + ''
          wrapProgram $out/bin/upwork \
            --prefix PATH : ${pkgs.lib.makeBinPath [xdg-open-chromium pkgs.chromium]}

          # Register upwork:// protocol handler
          sed -i 's/^MimeType=.*/MimeType=x-scheme-handler\/upwork;/' $out/share/applications/upwork.desktop
        '';
      nativeBuildInputs = (oldAttrs.nativeBuildInputs or []) ++ [pkgs.makeWrapper];
    }))
  ];

  xdg.mimeApps.defaultApplications = {
    "x-scheme-handler/upwork" = "upwork.desktop";
  };
}
