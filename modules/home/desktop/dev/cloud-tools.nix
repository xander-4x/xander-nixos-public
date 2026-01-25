{ pkgs, ... }: {
  home.packages = with pkgs; [
    # awscli2
    terraform
  ];

  home.sessionVariables = {
    AWS_PAGER = ""; # Disable less in AWS CLI
  };

  programs.zsh.shellAliases = {
    tf = "terraform";
  };
}
