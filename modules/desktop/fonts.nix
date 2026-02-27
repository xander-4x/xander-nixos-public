{pkgs, ...}: {
  fonts = {
    packages = with pkgs; [
      noto-fonts-color-emoji
      noto-fonts-cjk-sans
      nerd-fonts.jetbrains-mono
      font-awesome
      # symbola # TODO: upstream source unavailable (archive.org 503)
      noto-fonts
      material-icons
      fira-code
      fira-code-symbols
    ];
  };
}
