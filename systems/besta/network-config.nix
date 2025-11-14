{ pkgs, inputs, ... }:
{
  networking = {
    hostName = "besta";

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
  };

  ###########
  # NAT-PMP #
  ###########
  systemd.services.natpmp = {
    description = "NAT-PMP Port Mapping for 26504 via VPN gateway";
    wantedBy = [ "multi-user.target" ];

    after = [
      "systemd-networkd.service"
      "network-online.target"
    ];
    wants = [ "network-online.target" ];

    serviceConfig = {
      Type = "simple";
      Restart = "always";
      RestartSec = 5;
    };

    script = ''
      GATEWAY=10.2.0.1
      PORT=26504
      LIFETIME=60   # seconds

      # Wait until we can reach the NAT-PMP gateway
      for i in $(seq 1 30); do
        if ping -c1 -W1 "$GATEWAY" >/dev/null 2>&1; then
          echo "NAT-PMP: $GATEWAY reachable, starting loop"
          break
        fi
        echo "NAT-PMP: waiting for $GATEWAY to be reachable..."
        sleep 1
      done

      # Main renew loop
      while true; do
        date
        ${pkgs.libnatpmp}/bin/natpmpc -g "$GATEWAY" -a "$PORT" "$PORT" udp "$LIFETIME" &&
        ${pkgs.libnatpmp}/bin/natpmpc -g "$GATEWAY" -a "$PORT" "$PORT" tcp "$LIFETIME" || {
          echo "ERROR: natpmpc failed" >&2
          # keep trying rather than break; you can switch back to 'break' if you prefer
        }
        sleep 45
      done
    '';
  };
}
