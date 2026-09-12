{
  fileSystems."/media/Baitai" = {
    device = "10.1.10.101:/volume1/Baitai";
    fsType = "nfs";
    options = [
      "nfsvers=4.1"
      "nconnect=4"
      "_netdev"
      "x-systemd.automount"
      "noatime"
    ];
  };
}
