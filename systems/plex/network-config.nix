{
  networking = {
    #Hostname
    hostName = "plex";

    # Interface
    interfaces = {
      ens18.ipv4.addresses = [
        {
          address = "192.168.1.77";
          prefixLength = 24;
        }
      ];
    };
  };
}
