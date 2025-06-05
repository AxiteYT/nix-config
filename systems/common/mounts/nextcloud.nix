{
  fileSystems."/media/Nextcloud" = {
    device = "192.168.1.99:/mnt/Core-Pool/Nextcloud";
    fsType = "nfs";
    options = [ "nfsvers=4.2" ];
  };
}
