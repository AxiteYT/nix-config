{ pkgs, pkgsMaster, ... }:
{
  services.plex = {
    enable = true;
    openFirewall = true;
    package = pkgsMaster.plex;
  };
}
