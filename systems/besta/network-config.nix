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
}
