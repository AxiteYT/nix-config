{ pkgs, lib, ... }:
{
  # Configure actual for HTTPS on port 443 and open 80/443 in the firewall
  boot.kernel.sysctl."net.ipv4.ip_unprivileged_port_start" = 0;

  # Allow web port access
  networking = {
    firewall = {
      allowedTCPPorts = [
        80
        443
      ];
      enable = true;
    };
    useHostResolvConf = lib.mkForce false;
  };

  services.actual = {
    enable = true;
    openFirewall = true;

    settings = {
      port = 443;
      https = {
        key = "/var/lib/actual/certs/selfhost.key";
        cert = "/var/lib/actual/certs/selfhost.crt";
      };
    };
  };
}
