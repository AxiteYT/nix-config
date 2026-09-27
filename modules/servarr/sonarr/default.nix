{ pkgs, ... }:
{
  services.sonarr = {
    enable = true;
    group = "servarr";
    openFirewall = true;
  };
  systemd.services.sonarr.unitConfig.RequiresMountsFor = [ "/media/Baitai" ];
}
