{
  fileSystems."/media/Baitai" = {
    device = "10.10.40.10:/volume1/Baitai";
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
