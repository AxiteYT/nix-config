{ pkgs, ... }:
{
  # Networking Configuration
  networking = {
    #Hostname
    hostName = "besta";

    # Interface
    interfaces = {
      ens18.ipv4.addresses = [
        {
          address = "10.1.10.85";
          prefixLength = 24;
        }
      ];
      wg0 = {
        ipv4.routes = [
          {
            address = "10.1.10.0";
            prefixLength = 24;
          }
          {
            address = "10.1.1.0";
            prefixLength = 24;
          }
        ];
      };
    };
  };
}
