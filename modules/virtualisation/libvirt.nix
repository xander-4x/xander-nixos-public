{
  pkgs,
  username,
  ...
}: let
  # Fake ACL helper (always return SUCCESS)
  fake-acl-helper = pkgs.writeShellScriptBin "spice-client-glib-usb-acl-helper" ''
    #!/bin/sh
    read line
    echo "SUCCESS"
    exit 0
  '';
in {
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu.swtpm.enable = false;
    };
  };

  programs.virt-manager.enable = true;

  users.users.${username}.extraGroups = ["libvirtd" "kvm" "input" "disk"];

  environment.systemPackages = with pkgs; [
    remmina
    spice-gtk
    usbredir
    fake-acl-helper
  ];

  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", MODE="0666", GROUP="libvirtd", TAG+="uaccess"
  '';

  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (action.id == "org.libvirt.unix.manage" &&
          subject.isInGroup("libvirtd")) {
        return polkit.Result.YES;
      }
    });
  '';

  environment.sessionVariables = {
    SPICE_USB_ACL_BINARY = "${fake-acl-helper}/bin/spice-client-glib-usb-acl-helper";
  };

  systemd.services.libvirt-default-network = {
    description = "Ensure libvirt default NAT network exists and autostarts";
    after = ["libvirtd.service"];
    requires = ["libvirtd.service"];
    wantedBy = ["multi-user.target"];
    serviceConfig.Type = "oneshot";
    path = [pkgs.libvirt];
    script = ''
      set -eu

      # create NAT:
      # bridge: virbr0, subnet: 192.168.122.0/24
      if ! virsh net-info default >/dev/null 2>&1; then
        cat <<'XML' | virsh net-define /dev/stdin
      <network>
        <name>default</name>
        <forward mode='nat'/>
        <bridge name='virbr0' stp='on' delay='0'/>
        <ip address='192.168.122.1' netmask='255.255.255.0'>
          <dhcp>
            <range start='192.168.122.2' end='192.168.122.254'/>
          </dhcp>
        </ip>
      </network>
      XML
      fi

      virsh net-autostart default || true
      virsh net-start default || true
    '';
  };
}
