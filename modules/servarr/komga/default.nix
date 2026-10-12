{
  services.komga = {
    enable = true;
    group = "servarr";
    settings.server.port = 8789;
    openFirewall = true;
  };

  systemd.services.komga.unitConfig.RequiresMountsFor = [ "/media/Baitai" ];
}
