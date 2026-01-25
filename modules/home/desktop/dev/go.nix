{ pkgs, ... }: {
  home.packages = [
    pkgs.go_1_25
    pkgs.gcc
  ];
}