{pkgs, ...}: {
  home.packages = with pkgs; [pyprland];

  home.file.".config/hypr/pyprland.toml".text = ''
    [pyprland]
    plugins = [
      "scratchpads",
    ]

    [scratchpads.term]
    animation = "fromTop"
    command = "wezterm --class kitty-dropterm"
    class = "wezterm-dropterm"
    size = "75% 60%"
    max_size = "1920px 100%"
  '';
}
