{
  config,
  lib,
  pkgs,
  username,
  ...
}:

let
  homeDir = "/home/${username}";
  desktopDir = "${homeDir}/.local/share/applications";

  appimageEntries = [
    {
      name = "YouGile";
      path = "${homeDir}/Applications/YouGile.AppImage";
      icon = "${homeDir}/Applications/YouGile.png";
      categories = [ "Utility" ];
    }
    # {
    #   name = "myapp";
    #   path = "/home/you/Applications/myapp.AppImage";
    #   icon = "/home/you/Applications/myapp.png";
    #   categories = ["Utility"];
    # }

  ];

  makeHomeFileEntry = app: {
    name = "${desktopDir}/${app.name}.desktop";
    value = {
      text = ''
        [Desktop Entry]
        Name=${app.name}
        Exec=${pkgs.appimage-run}/bin/appimage-run ${app.path}
        Icon=${if app.icon != null then app.icon else app.name}
        Type=Application
        Categories=${lib.concatStringsSep ";" app.categories};
        Terminal=false
      '';
    };
  };
in
{
  home.packages = [
    pkgs.appimage-run
  ];

  home.file = builtins.listToAttrs (map makeHomeFileEntry appimageEntries);
}
