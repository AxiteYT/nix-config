{ pkgs, ... }:
{
  services.actual = {
    enable = true;
    openFirewall = true;

    settings = {
      port = 5006;
      https = {
        key = "/home/actual/certs/selfhost.key";
        cert = "/home/actual/certs/selfhost.key";
      };
    };
  };
}
