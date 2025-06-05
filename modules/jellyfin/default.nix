{
  services.jellyfin = {
    enable = true;
    openFirewall = true;
    group = "plex";
    user = "plex";
  };
}
