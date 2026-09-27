{
  services.bazarr = {
    enable = true;
    group = "servarr";
    openFirewall = true;
  };
  systemd.services.bazarr.unitConfig.RequiresMountsFor = [ "/media/Baitai" ];
}
