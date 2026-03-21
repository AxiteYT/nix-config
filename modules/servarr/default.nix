{
  imports = [
    ../qbittorrent
    ./bazarr
    ./flaresolverr
    ./prowlarr
    ./radarr
    ./sonarr
    ./tdarr
  ];

  users.groups.servarr = { };
}
