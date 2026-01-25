{pkgs, ...}: {
  home.packages = with pkgs; [zsh];

  home.file."./.zshrc-personal".text = ''

    # This file allows you to define your own aliases, functions, etc
    # below are just some examples of what you can use this file for

      #!/usr/bin/env zsh
      # Set defaults
      #
      export EDITOR="nvim"
      export VISUAL="nvim"
      export SSH_AUTH_SOCK="/run/user/1000/gcr/ssh"

  '';
}
