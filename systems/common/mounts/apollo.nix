{
  fileSystems."/Apollo" = {
    device = "/dev/sda1";
    fsType = "ntfs-3g"; # TODO: Change
    options = [
      "rw"
      "uid=1000"
    ];
  };
}
