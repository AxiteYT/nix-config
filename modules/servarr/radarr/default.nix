{
  services.radarr = {
    enable = true;
    group = "servarr";
    openFirewall = true;
  };
  systemd.services.radarr.unitConfig.RequiresMountsFor = [ "/media/Baitai" ];
}
