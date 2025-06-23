{
  networking = {
    #Hostname
    hostName = "actual";

    # Interface
    interfaces = {
      ens18.ipv4.addresses = [
        {
          address = "192.168.1.101";
          prefixLength = 24;
        }
      ];
    };
  };
}
