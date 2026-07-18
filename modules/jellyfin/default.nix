{ config, pkgs, ... }:
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

    forceEncodingConfig = false;

    hardwareAcceleration = {
      enable = true;
      type = "vaapi";
      device = "/dev/dri/renderD128";
    };

    transcoding = {
      enableHardwareEncoding = true;
      hardwareDecodingCodecs = {
        h264 = true;
        hevc = true;
        hevc10bit = true;
        mpeg2 = true;
        vc1 = true;
        vp8 = true;
        vp9 = true;
      };
      hardwareEncodingCodecs.hevc = true;
      enableToneMapping = true;
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
    path = [ pkgs.jellyfin-ffmpeg ];
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
