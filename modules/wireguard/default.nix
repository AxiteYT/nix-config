{ pkgs, ... }:
{
  # WG Application
  environment.systemPackages = with pkgs; [
    wireguard-tools
    libnatpmp
  ];

  # WireGuard VPN Configuration
  networking = {
    wg-quick.interfaces.wg0 = {
      address = [ "10.2.0.2/32" ];
      dns = [ "10.2.0.1" ];
      privateKeyFile = "/root/.wg/besta-AU-1.key";
      peers = [
        {
          publicKey = "dpcwy7V6UxFxZ5BEYED5w30sqpz2Bak+7HchFbUNHUw=";
          endpoint = "180.149.228.66:51820";
          allowedIPs = [ "0.0.0.0/0" ];
          persistentKeepalive = 25;
        }
      ];

      # postRules to allow localtraffic
      postUp = ''
        wg set wg0 fwmark 51820
        ${pkgs.iptables}/bin/iptables -t mangle -A OUTPUT -o wg0 -m mark --mark 51820 -j ACCEPT
        ${pkgs.iptables}/bin/iptables -t mangle -A OUTPUT ! -o wg0 -m addrtype --dst-type LOCAL -j ACCEPT
        ${pkgs.iptables}/bin/iptables -t mangle -A OUTPUT ! -o wg0 -d 192.168.1.0/24 -j ACCEPT
        ${pkgs.iptables}/bin/iptables -t mangle -A OUTPUT ! -o wg0 -d 10.1.1.0/24 -j ACCEPT
        ${pkgs.iptables}/bin/iptables -t mangle -A OUTPUT ! -o wg0 -m mark --mark 0 -j MARK --set-xmark 51820
      '';

      postDown = ''
        ${pkgs.iptables}/bin/iptables -t mangle -D OUTPUT -o wg0 -m mark --mark 51820 -j ACCEPT
        ${pkgs.iptables}/bin/iptables -t mangle -D OUTPUT ! -o wg0 -m addrtype --dst-type LOCAL -j ACCEPT
        ${pkgs.iptables}/bin/iptables -t mangle -D OUTPUT ! -o wg0 -d 192.168.1.0/24 -j ACCEPT
        ${pkgs.iptables}/bin/iptables -t mangle -D OUTPUT ! -o wg0 -d 10.1.1.0/24 -j ACCEPT
        ${pkgs.iptables}/bin/iptables -t mangle -D OUTPUT ! -o wg0 -m mark --mark 0 -j MARK --set-xmark 0
      '';
    };

    firewall = {
      allowedTCPPorts = [ 26504 ];
      allowedUDPPorts = [ 26504 ];
    };
  };

  # NAT-PMP Service for Port Mapping
  systemd.services.natpmp = {
    description = "NAT-PMP Port Mapping Service";
    after = [
      "network-online.target"
      "wg-quick-wg0.service"
    ];
    wants = [
      "network-online.target"
      "wg-quick-wg0.service"
    ];
    requires = [ "wg-quick-wg0.service" ];
    wantedBy = [ "multi-user.target" ];

    script = ''
      ${pkgs.libnatpmp}/bin/natpmpc -a 26504 26504 udp 60 -g 10.2.0.1
      ${pkgs.libnatpmp}/bin/natpmpc -a 26504 26504 tcp 60 -g 10.2.0.1
      while true; do
          date
          ${pkgs.libnatpmp}/bin/natpmpc -a 26504 26504 udp 60 -g 10.2.0.1 &&
          ${pkgs.libnatpmp}/bin/natpmpc -a 26504 26504 tcp 60 -g 10.2.0.1 || {
              echo -e "ERROR with natpmpc command \a"
              break
          }
          sleep 45
      done
    '';

    serviceConfig = {
      Type = "simple";
      Restart = "always";
      RestartSec = 5;
    };
  };

  # IP Forwarding
  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;
}
