{ config, pkgs, lib, ... }:

{
  options = {
    services.ssh-agent.enable = lib.mkEnableOption "Enable system-wide SSH agent using gnome-keyring";
  };

  config = lib.mkIf config.services.ssh-agent.enable {
    programs.ssh.startAgent = lib.mkForce false;

    environment.sessionVariables = {
      SSH_AUTH_SOCK = "/run/user/1000/keyring/ssh";
    };

    systemd.user.services.gnome-keyring-ssh = {
      Unit = {
        Description = "GNOME Keyring SSH Agent";
        After = [ "graphical-session.target" ];
      };

      Service = {
        Type = "simple";
        ExecStart = "${pkgs.gnome.gnome-keyring}/libexec/gnome-keyring-daemon --start --components=ssh";
        Environment = "SSH_AUTH_SOCK=%t/keyring/ssh";
        Restart = "on-failure";
      };

      Install = {
        WantedBy = [ "default.target" ];
      };
    };
  };
}
