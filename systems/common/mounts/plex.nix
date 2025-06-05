{
  fileSystems."/media/Plex" = {
    device = "192.168.1.99:/mnt/Core-Pool/Plex";
    fsType = "nfs";
    options = [ "nfsvers=4.2" ];
  };
}
