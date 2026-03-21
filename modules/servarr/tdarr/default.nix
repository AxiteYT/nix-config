{ config, pkgs, ... }:
{
  systemd.services.tdarr-server = {
    description = "Tdarr Server";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];

    environment = {
      rootDataPath = "/var/lib/tdarr/server";
    };

    serviceConfig = {
      Type = "simple";
      User = "plex";
      Group = "plex";
      SupplementaryGroups = [
        "render"
        "video"
      ];
      ExecStart = "${pkgs.tdarr-server}/bin/tdarr-server";
      Restart = "on-failure";
      RestartSec = "5s";
      StateDirectory = "tdarr/server";
      RequiresMountsFor = [ "/media/Plex" ];
      NoNewPrivileges = true;
      PrivateTmp = true;
    };
  };

  systemd.services.tdarr-node = {
    description = "Tdarr Node";
    after = [
      "network-online.target"
      "tdarr-server.service"
    ];
    wants = [ "network-online.target" ];
    requires = [ "tdarr-server.service" ];
    wantedBy = [ "multi-user.target" ];

    environment = {
      nodeName = config.networking.hostName;
      rootDataPath = "/var/lib/tdarr/node";
      serverIP = "127.0.0.1";
      serverPort = "8266";
      serverURL = "http://127.0.0.1:8266";
    };

    serviceConfig = {
      Type = "simple";
      User = "plex";
      Group = "plex";
      SupplementaryGroups = [
        "render"
        "video"
      ];
      ExecStart = "${pkgs.tdarr-node}/bin/tdarr-node";
      Restart = "on-failure";
      RestartSec = "5s";
      StateDirectory = "tdarr/node";
      RequiresMountsFor = [ "/media/Plex" ];
      NoNewPrivileges = true;
      PrivateTmp = true;
    };
  };

  networking.firewall.allowedTCPPorts = [
    8265
    8266
  ];
}
