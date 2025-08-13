{
  networking = {
    #Hostname
    hostName = "plex";

    # Interface
    interfaces = {
      ens18.ipv4.addresses = [
        {
          address = "10.1.10.77";
          prefixLength = 24;
        }
      ];
    };
  };
}
