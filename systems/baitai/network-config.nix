{
  networking = {
    #Hostname
    hostName = "baitai";

    # Interface
    interfaces = {
      ens18.ipv4.addresses = [
        {
          address = "10.10.30.77";
          prefixLength = 24;
        }
      ];
    };
  };
}
