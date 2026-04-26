{ config, pkgs, ... }:
let
  tdarrPackage =
    pkg:
    pkg.overrideAttrs (_: {
      autoPatchelfIgnoreMissingDeps = [ "libc.musl-x86_64.so.1" ];
    });

  tdarrServer = tdarrPackage pkgs.tdarr-server;
  tdarrNode = tdarrPackage pkgs.tdarr-node;
in
{
  systemd.services.tdarr-server = {
    description = "Tdarr Server";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    unitConfig = {
      RequiresMountsFor = [ "/media/Baitai" ];
    };

    environment = {
      inContainer = "true";
      openBrowser = "false";
      rootDataPath = "/var/lib/tdarr/server";
    };

    serviceConfig = {
      Type = "simple";
      User = "baitai";
      Group = "baitai";
      SupplementaryGroups = [
        "render"
        "video"
      ];
      ExecStart = "${tdarrServer}/bin/tdarr-server";
      Restart = "on-failure";
      RestartSec = "5s";
      StateDirectory = "tdarr/server";
      NoNewPrivileges = true;
      PrivateTmp = true;
      TemporaryFileSystem = "/temp:rw,mode=1777";
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
    unitConfig = {
      RequiresMountsFor = [ "/media/Baitai" ];
    };

    environment = {
      inContainer = "true";
      nodeName = config.networking.hostName;
      rootDataPath = "/var/lib/tdarr/node";
      serverIP = "127.0.0.1";
      serverPort = "8266";
      serverURL = "http://127.0.0.1:8266";
    };

    serviceConfig = {
      Type = "simple";
      User = "baitai";
      Group = "baitai";
      SupplementaryGroups = [
        "render"
        "video"
      ];
      ExecStart = "${tdarrNode}/bin/tdarr-node";
      Restart = "on-failure";
      RestartSec = "5s";
      StateDirectory = "tdarr/node";
      NoNewPrivileges = true;
      PrivateTmp = true;
      TemporaryFileSystem = "/temp:rw,mode=1777";
    };
  };

  networking.firewall.allowedTCPPorts = [
    8265
    8266
  ];
}
