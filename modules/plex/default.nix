{ pkgs, inputs, ... }:
{
  services.plex = {
    enable = true;
    openFirewall = true;
    package = pkgsMaster.plex;
  };
}
