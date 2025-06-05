{
  modulesPath,
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    ../../hardware/qemu-guest
  ];

  # Disable DHCP
  networking = {
    useDHCP = false;
    defaultGateway = "192.168.1.1";
    nameservers = [ "192.168.1.1" ];
  };

  # Enable serial port
  boot.kernelParams = [
    "console=ttyS0,115200n8"
  ];
}
