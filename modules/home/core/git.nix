{ host, ... }:
let
  inherit (import ../../../hosts/${host}/variables.nix) gitUsername gitEmail;
in
{
  programs.git = {
    enable = true;
    signing.format = null;
    settings.user ={
      name = "${gitUsername}";
      email = "${gitEmail}";
    };
  };
}
