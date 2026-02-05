{ config, lib, ... }:
{
  networking = {
    hostName = "axtop";
    networkmanager.enable = true;
    wireless.enable = true;
    useDHCP = lib.mkDefault true;
  };
}
