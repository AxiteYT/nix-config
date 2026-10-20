{ config, lib, ... }:
{
  networking = {
    hostName = "axnix";
    networkmanager.enable = true;
    useDHCP = lib.mkDefault true;
    hosts = {
      "0.0.0.0" = [
        "test-s1.battleye.com"
        "paradiseenhanced-s1.battleye.com"
      ];
    };
  };
}
