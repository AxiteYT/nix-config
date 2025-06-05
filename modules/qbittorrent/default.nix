{ pkgs, ... }:
{
  imports = [ ../services/torrent/qbittorrent.nix ];

  services.qbittorrent = {
    enable = true;
    openFirewall = true;
    dataDir = "/var/lib/qbittorrent";
    user = "qbittorrent";
    group = "servarr";
    port = 8443;
  };
}
