{ pkgs, inputs, ... }:
let
  pkgsMaster = import inputs.pkgsMaster {
    system = pkgs.stdenv.hostPlatform.system;
    config = {
      allowUnfree = true;
    };
  };
in
{
  services.plex = {
    enable = true;
    openFirewall = true;
    package = pkgsMaster.plex;
  };
}
