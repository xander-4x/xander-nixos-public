{...}: {
  # SSH agent for git operations with private repos
  # Key is added automatically on first use (requires passphrase once per session)
  programs.ssh = {
    startAgent = true;
    extraConfig = ''
      AddKeysToAgent yes
    '';
  };

  services = {
    # SSH with hardened settings
    openssh = {
      enable = true;
      ports = [ 47821 ];
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        X11Forwarding = false;
        MaxAuthTries = 3;
        LoginGraceTime = 20;
      };
    };

    # SSD optimization
    fstrim.enable = true;

    # Tailscale VPN
    tailscale.enable = true;

    # Fail2ban for brute-force protection
    fail2ban = {
      enable = true;
      maxretry = 3;
      bantime = "1h";
      bantime-increment = {
        enable = true;
        maxtime = "168h"; # 1 week max ban
        factor = "4";
      };
    };
  };
}
