{
  networking = {
    #Hostname
    hostName = "tukku";

    # Interface
    interfaces = {
      ens18.ipv4.addresses = [
        {
          address = "10.1.10.15";
          prefixLength = 24;
        }
      ];
    };
  };
}
