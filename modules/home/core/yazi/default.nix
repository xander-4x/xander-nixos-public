{pkgs, ...}: {
  programs.yazi = {
    enable = true;
    package = pkgs.yazi;
    shellWrapperName = "y";
  };

  home.packages = with pkgs; [
    file # Required for yazi mime type detection
  ];

  home.file = {
    ".config/yazi" = {
      source = ../yazi;
      recursive = true;
    };
  };
}
