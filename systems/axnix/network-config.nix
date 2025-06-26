{ config, lib, ... }:
{
  networking = {
    hostName = "axnix";
    networkmanager.enable = true;
    useDHCP = lib.mkDefault true;
    firewall = {
      allowedTCPPortRanges = [
        {
          from = 0;
          to = 64738;
        }
      ];
      allowedUDPPortRanges = [
        {
          from = 0;
          to = 64738;
        }
      ];
    };
  };
}
