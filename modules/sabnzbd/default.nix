let
  mediaPath = "/media/Baitai";
  downloadPath = "${mediaPath}/Downloads";
in
{
  services.sabnzbd = {
    enable = true;
    group = "servarr";
    openFirewall = true;

    # Besta's state version otherwise selects the deprecated unmanaged config.
    configFile = null;
    allowConfigWrite = true;

    settings.misc = {
      host = "0.0.0.0";
      port = 8080;
      download_dir = "${downloadPath}/incomplete";
      complete_dir = "${downloadPath}/complete";
    };
  };

  systemd.services.sabnzbd = {
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    unitConfig.RequiresMountsFor = mediaPath;
    serviceConfig.UMask = "0002";
  };
}
