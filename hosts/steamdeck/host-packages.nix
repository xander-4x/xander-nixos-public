{pkgs, inputs, ...}: {
  programs = {
    dconf.enable = true;
    seahorse.enable = true;
    fuse.userAllowOther = true;
    mtr.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = false;
    };
  };

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [ "electron-39.8.10" ];

  environment.systemPackages = with pkgs; [
    p7zip
    bind # inet tools
    bitwarden-desktop # Password manager
    brave # Brave Browser
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default # Zen Browser
    brightnessctl # For Screen Brightness Control
    cmatrix # Matrix Movie Effect In Terminal
    duf # Utility For Viewing Disk Usage In Terminal
    discord
    eza # Beautiful ls Replacement
    ffmpeg # Terminal Video / Audio Editing
    mesa-demos # needed for inxi diag util
    gimp3 # image manipulation program
    inetutils # inet tools
    inxi # CLI System Information Tool
    killall # For Killing All Instances Of Programs
    libnotify # For Notifications
    libreoffice-qt6-fresh # Office
    lm_sensors # Used For Getting Hardware Temps
    lolcat # Add Colors To Your Terminal Command Output
    lshw # Detailed Hardware Information
    mpv # Incredible Video Player
    ncdu # Disk Usage Analyzer With Ncurses Interface
    nixfmt # Nix Formatter
    nmap # Utility for network discovery and security auditing
    obsidian # powerful notes
    onefetch # provides os build info on current system
    openssl
    openvpn
    pciutils # Collection Of Tools For Inspecting PCI Devices
    picard # For Changing Music Metadata & Getting Cover Art
    pkg-config # Wrapper Script For Allowing Packages To Get Info On Others
    playerctl # Allows Changing Media Volume Through Scripts
    qalculate-qt # powerful calculator
    zathura # document / PDF reader (vim-style navigation)
    qbittorrent # torrent client
    ripgrep # Improved Grep
    socat # General-purpose socket relay
    sshfs # SSH Filesystem - Mount Remote Directories
    unrar # Tool For Handling .rar Files
    unzip # Tool For Handling .zip Files
    usbutils # Good Tools For USB Devices
    vesktop # opensource discord alternative
    v4l-utils # Used For Things Like OBS Virtual Camera
    wget # Tool For Fetching Files With Links
    zoom-us # video conferencing application
  ];
}
