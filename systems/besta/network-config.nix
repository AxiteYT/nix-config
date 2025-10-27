{ pkgs, inputs, ... }:
{
  ############################
  # Base networking
  ############################
  networking = {
    hostName = "besta";

    # Use systemd-networkd for everything
    useNetworkd = true;

    # LAN interface (static)
    defaultGateway = {
      address = "10.1.10.1";
      interface = "ens18";
    };
    interfaces.ens18 = {
      ipv4.addresses = [
        {
          address = "10.1.10.85";
          prefixLength = 24;
        }
      ];
    };

    # Firewall (open 26504)
    firewall = {
      enable = true;
      allowedTCPPorts = [ 26504 ];
      allowedUDPPorts = [ 26504 ];
      checkReversePath = "loose";
    };
  };

  environment.systemPackages = with pkgs; [
    wireguard-tools
    libnatpmp
  ];

  sops.secrets."BestaWG/key" = {
    owner = "systemd-network";
    group = "systemd-network";
    mode = "0400";
    # make sure networkd restarts when the secret is (re)installed
    restartUnits = [ "systemd-networkd.service" ];
  };

  ############################
  # WireGuard via systemd-networkd
  ############################
  systemd.network.netdevs."wg0" = {
    netdevConfig = {
      Kind = "wireguard";
      Name = "wg0";
    };
    wireguardConfig = {
      PrivateKeyFile = "/run/secrets/BestaWG/key";
      FirewallMark = 51820;
    };
    wireguardPeers = [
      {
        PublicKey = "dpcwy7V6UxFxZ5BEYED5w30sqpz2Bak+7HchFbUNHUw=";
        Endpoint = "180.149.228.66:51820";
        AllowedIPs = [ "0.0.0.0/0" ];
        PersistentKeepalive = 25;
      }
    ];
  };

  systemd.network.networks."40-wg0" = {
    matchConfig.Name = "wg0";

    # must be a list of attrsets
    addresses = [
      { Address = "10.2.0.2/32"; }
    ];

    networkConfig.DNS = [ "10.2.0.1" ];

    routes = [
      {
        Destination = "0.0.0.0/0";
        Table = 51820;
        Scope = "link";
      }
    ];

    routingPolicyRules = [
      {
        To = "10.1.0.0/24";
        Table = "main";
        Priority = 100;
      }
      {
        To = "10.1.10.0/24";
        Table = "main";
        Priority = 101;
      }
      {
        To = "10.1.20.0/24";
        Table = "main";
        Priority = 102;
      }
      {
        To = "10.1.1.0/24";
        Table = "main";
        Priority = 103;
      }

      # keep 'InvertRule' (systemd key name)
      {
        FirewallMark = 51820;
        InvertRule = true;
        Table = 51820;
        Priority = 200;
      }
    ];
  };

  ############################
  # NAT-PMP (keeps 26504 mapped on the WG gateway)
  ############################
  systemd.services.natpmp = {
    description = "NAT-PMP Port Mapping for 26504 via wg0";
    wantedBy = [ "multi-user.target" ];
    requires = [ "sys-subsystem-net-devices-wg0.device" ];
    bindsTo = [ "sys-subsystem-net-devices-wg0.device" ];
    after = [
      "systemd-networkd.service"
      "sys-subsystem-net-devices-wg0.device"
      "network-online.target"
    ];
    wants = [ "network-online.target" ];

    serviceConfig = {
      Type = "simple";
      Restart = "always";
      RestartSec = 5;
    };

    script = ''
      # Wait until wg0 has its address
      for i in $(seq 1 30); do
        ip -4 addr show dev wg0 | grep -q "10\.2\.0\.2/32" && break
        sleep 1
      done

      ${pkgs.libnatpmp}/bin/natpmpc -a 26504 26504 udp 60 -g 10.2.0.1
      ${pkgs.libnatpmp}/bin/natpmpc -a 26504 26504 tcp 60 -g 10.2.0.1
      while true; do
        date
        ${pkgs.libnatpmp}/bin/natpmpc -a 26504 26504 udp 60 -g 10.2.0.1 &&
        ${pkgs.libnatpmp}/bin/natpmpc -a 26504 26504 tcp 60 -g 10.2.0.1 || {
          echo "ERROR: natpmpc failed" >&2
          break
        }
        sleep 45
      done
    '';
  };

  ############################
  # Misc
  ############################
  services.resolved.enable = true;
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv4.conf.all.src_valid_mark" = 1;
  };
}
