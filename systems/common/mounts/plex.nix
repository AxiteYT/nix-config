{
  fileSystems."/media/Plex" = {
    device = "10.1.10.10:/mnt/Core-Pool/Plex";
    fsType = "nfs";
    options = [ "nfsvers=4.2" ];
  };
}
