{ config, ... }:
let
  mediaPath = "/media/Baitai";
  jellyfinHost = "jellyfin.${config.networking.domain}";
  jellyfinStateDir = "/var/lib/jellyfin";
in
{
  services.jellyfin = {
    enable = true;
    openFirewall = true;

    dataDir = jellyfinStateDir;
    configDir = "${jellyfinStateDir}/config";
    cacheDir = "/var/cache/jellyfin";
    logDir = "/var/log/jellyfin";

    forceEncodingConfig = true;

    hardwareAcceleration = {
      enable = true;
      type = "vaapi";
      device = "/dev/dri/renderD128";
    };

    transcoding = {
      deleteSegments = true;
      enableHardwareEncoding = true;
      enableToneMapping = true;
      throttleTranscoding = true;
    };
  };

  users.groups.baitai = { };
  users.users.jellyfin.extraGroups = [
    "baitai"
    "render"
    "video"
  ];

  systemd.services.jellyfin = {
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    unitConfig.RequiresMountsFor = mediaPath;
  };

  networking.firewall.allowedTCPPorts = [
    80
  ];

  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;

    virtualHosts.${jellyfinHost} = {
      locations."/" = {
        proxyPass = "http://127.0.0.1:8096";
        proxyWebsockets = true;
        extraConfig = ''
          client_max_body_size 20M;
          proxy_buffering off;
        '';
      };
    };
  };
}
