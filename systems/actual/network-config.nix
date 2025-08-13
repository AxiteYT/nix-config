{
  networking = {
    #Hostname
    hostName = "actual";

    # Interface
    interfaces = {
      ens18.ipv4.addresses = [
        {
          address = "10.1.10.101";
          prefixLength = 24;
        }
      ];
    };
  };
}
