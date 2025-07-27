{ pkgs, ... }:
{
  services.qbittorrent = {
    enable = true;
    openFirewall = true;
    user = "qbittorrent";
    group = "servarr";
    webuiPort = 8443;
    torrentingPort = 26504;
  };
}
