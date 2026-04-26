{
  imports = [
    ../qbittorrent
    ./bazarr
    ./flaresolverr
    ./prowlarr
    ./radarr
    ./recyclarr
    ./sonarr
  ];

  users.groups.servarr = { };
}
