{ pkgs, host, ... }: let
  inherit (import ../../../hosts/${host}/variables.nix) browser terminal;
in {
  xdg = {
    enable = true;
    mime.enable = true;

    desktopEntries.nvim = {
      name = "Neovim";
      genericName = "Text Editor";
      comment = "Edit text files";
      exec = "${terminal} -e nvim %F";
      icon = "nvim";
      terminal = false;
      type = "Application";
      categories = [ "Utility" "TextEditor" ];
      mimeType = [
        "text/plain"
        "text/x-python"
        "text/x-shellscript"
        "text/x-csrc"
        "text/x-c++src"
        "text/x-chdr"
        "text/x-c++hdr"
        "text/markdown"
        "text/x-makefile"
        "application/json"
        "application/xml"
        "application/javascript"
        "text/x-lua"
        "text/x-rust"
        "text/x-go"
        "text/x-java"
        "text/x-ruby"
        "text/x-tex"
        "text/html"
        "text/css"
      ];
    };

    mimeApps = {
      enable = true;

      defaultApplications = {
        # PDF
        "application/pdf" = [ "org.pwmt.zathura.desktop" ];

        # Web Browser (from variables.nix)
        "text/html" = [ "${browser}.desktop" ];
        "x-scheme-handler/http" = [ "${browser}.desktop" ];
        "x-scheme-handler/https" = [ "${browser}.desktop" ];
        "x-scheme-handler/about" = [ "${browser}.desktop" ];
        "x-scheme-handler/unknown" = [ "${browser}.desktop" ];

        # Code/Text → Neovim
        "text/plain"         = [ "nvim.desktop" ];
        "text/x-python"      = [ "nvim.desktop" ];
        "text/x-shellscript" = [ "nvim.desktop" ];
        "text/x-csrc"        = [ "nvim.desktop" ];
        "text/x-c++src"      = [ "nvim.desktop" ];
        "application/json"   = [ "nvim.desktop" ];
        "application/xml"    = [ "nvim.desktop" ];

        # Images → Eye of GNOME
        "image/png"      = [ "org.gnome.eog.desktop" ];
        "image/jpeg"     = [ "org.gnome.eog.desktop" ];
        "image/webp"     = [ "org.gnome.eog.desktop" ];
        "image/svg+xml"  = [ "org.gnome.eog.desktop" ];
        "image/tiff"     = [ "org.gnome.eog.desktop" ];
        "image/gif"      = [ "org.gnome.eog.desktop" ];
      };

      associations.added = {
        "image/png"      = [ "org.gnome.eog.desktop" "swappy.desktop" ];
        "image/jpeg"     = [ "org.gnome.eog.desktop" "swappy.desktop" ];
        "image/webp"     = [ "org.gnome.eog.desktop" "swappy.desktop" ];
        "image/svg+xml"  = [ "org.gnome.eog.desktop" "swappy.desktop" ];
        "image/tiff"     = [ "org.gnome.eog.desktop" "swappy.desktop" ];
        "image/gif"      = [ "org.gnome.eog.desktop" "swappy.desktop" ];
      };
    };

    portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-hyprland pkgs.xdg-desktop-portal-gtk];
      configPackages = [ pkgs.hyprland ];
    };
  };
}
