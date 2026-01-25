{pkgs, ...}: {
  programs.bat = {
    enable = true;
    config = {
      pager = "less -FR";
    };
    extraPackages = with pkgs.bat-extras; [
      batman
      batpipe
      # batgrep  # Temporarily disabled due to failing tests
    ];
  };
}
