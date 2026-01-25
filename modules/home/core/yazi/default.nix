{pkgs, ...}: {
  programs.yazi = {
    enable = true;
    package = pkgs.yazi;
  };

  home.file = {
    ".config/yazi" = {
      source = ../yazi;
      recursive = true;
    };
  };
}
