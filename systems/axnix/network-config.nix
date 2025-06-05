{ config, lib, ... }:
{
  networking = {
    hostName = "axnix";
    networkmanager.enable = true;
    useDHCP = lib.mkDefault true;
  };
}
