{pkgs, ...}: {
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    kernel.sysctl = {
      "net.ipv4.ip_forward" = "1";
      "vm.swappiness" = 10;
    };
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };
}
