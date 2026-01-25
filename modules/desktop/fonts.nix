{pkgs, ...}: {
  fonts = {
    packages = with pkgs; [
      noto-fonts-color-emoji
      noto-fonts-cjk-sans
      nerd-fonts.jetbrains-mono
      font-awesome
      symbola
      material-icons
      fira-code
      fira-code-symbols
    ];
  };
}
