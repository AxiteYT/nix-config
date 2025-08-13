{
  fileSystems."/media/Nextcloud" = {
    device = "10.1.10.99:/mnt/Core-Pool/Nextcloud";
    fsType = "nfs";
    options = [ "nfsvers=4.2" ];
  };
}
