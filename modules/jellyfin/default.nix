{
  services.jellyfin = {
    enable = true;
    openFirewall = true;
    group = "baitai";
    user = "baitai";
  };
}
