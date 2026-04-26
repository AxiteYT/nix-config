{
  config,
  pkgs,
  inputs,
  ...
}:

{
  sops.secrets.BestaQB = { };
  sops.secrets.BestaQuiPassword = {
    owner = "qbittorrent";
    group = "servarr";
    mode = "0400";
  };

  sops.templates."qBittorrent.conf" = {
    content = ''
      [Application]
      FileLogger\Age=1
      FileLogger\AgeType=1
      FileLogger\Backup=true
      FileLogger\DeleteOld=true
      FileLogger\Enabled=true
      FileLogger\MaxSizeBytes=66560
      FileLogger\Path=/var/lib/qBittorrent/qBittorrent/config/qBittorrent/data/logs
      MemoryWorkingSetLimit=8192

      [BitTorrent]
      Session\AddExtensionToIncompleteFiles=true
      Session\AlternativeGlobalDLSpeedLimit=0
      Session\AlternativeGlobalUPSpeedLimit=0
      Session\BTProtocol=TCP
      Session\BandwidthSchedulerEnabled=true
      Session\DefaultSavePath=/media/Baitai/Downloads
      Session\ExcludedFileNames=
      Session\GlobalDLSpeedLimit=1
      Session\GlobalMaxInactiveSeedingMinutes=1440
      Session\GlobalMaxRatio=2
      Session\GlobalMaxSeedingMinutes=1440
      Session\GlobalUPSpeedLimit=1
      Session\IgnoreSlowTorrentsForQueueing=true
      Session\MaxActiveDownloads=5
      Session\MaxActiveTorrents=20
      Session\MaxActiveUploads=5
      Session\Port=26504
      Session\QueueingSystemEnabled=false
      Session\SSL\Port=17335
      Session\SlowTorrentsDownloadRate=100
      Session\TempPath=/media/Baitai/Downloads
      Session\UseAlternativeGlobalSpeedLimit=false

      [Core]
      AutoDeleteAddedTorrentFile=Never

      [Meta]
      MigrationVersion=8

      [Network]
      Cookies=@Invalid()
      PortForwardingEnabled=false

      [Preferences]
      General\Locale=en
      MailNotification\req_auth=true
      Scheduler\days=Weekday
      Scheduler\end_time=@Variant(\0\0\0\xf\x3n\xe8\0)
      Scheduler\start_time=@Variant(\0\0\0\xf\0\0\0\0)
      WebUI\Address=127.0.0.1
      WebUI\LocalHostAuth=false
      WebUI\Password_PBKDF2=${config.sops.placeholder.BestaQB}
      WebUI\Port=8443
      WebUI\Username=besta

      [RSS]
      AutoDownloader\DownloadRepacks=true
      AutoDownloader\SmartEpisodeFilter=s(\\d+)e(\\d+), (\\d+)x(\\d+), "(\\d{4}[.\\-]\\d{1,2}[.\\-]\\d{1,2})", "(\\d{1,2}[.\\-]\\d{1,2}[.\\-]\\d{4})"
    '';
    path = "/var/lib/qBittorrent/qBittorrent/config/qBittorrent.conf";
    owner = "qbittorrent";
    group = "servarr";
    mode = "0640";
  };

  services.qbittorrent = {
    enable = true;
    openFirewall = false;
    user = "qbittorrent";
    group = "servarr";
    webuiPort = 8443;
    torrentingPort = 26504;
  };

  systemd.services.qui = {
    description = "qui for qBittorrent";
    after = [
      "network-online.target"
      "qbittorrent.service"
    ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];

    preStart = ''
      qui_password="$(cat ${config.sops.secrets.BestaQuiPassword.path})"

      if [ ! -f /var/lib/qui/config.toml ]; then
        ${pkgs.qui}/bin/qui generate-config --config-dir /var/lib/qui
      fi

      if [ ! -f /var/lib/qui/qui.db ]; then
        ${pkgs.qui}/bin/qui create-user \
          --config-dir /var/lib/qui \
          --data-dir /var/lib/qui \
          --username besta \
          --password "$qui_password"
      else
        ${pkgs.qui}/bin/qui change-password \
          --config-dir /var/lib/qui \
          --data-dir /var/lib/qui \
          --username besta \
          --new-password "$qui_password"
      fi
    '';

    serviceConfig = {
      Type = "simple";
      User = "qbittorrent";
      Group = "servarr";
      StateDirectory = "qui";
      WorkingDirectory = "/var/lib/qui";
      ExecStart = ''
        ${pkgs.qui}/bin/qui serve \
          --config-dir /var/lib/qui \
          --data-dir /var/lib/qui
      '';
      Restart = "on-failure";
      RestartSec = "5s";
      NoNewPrivileges = true;
      PrivateTmp = true;
      ProtectSystem = "strict";
      ProtectHome = true;
      ReadWritePaths = [ "/var/lib/qui" ];
    };

    environment = {
      QUI__HOST = "0.0.0.0";
      QUI__PORT = "7476";
      QUI__DATA_DIR = "/var/lib/qui";
      QUI__LOG_LEVEL = "INFO";
    };
  };

  networking.firewall.allowedTCPPorts = [
    7476
    26504
  ];
  networking.firewall.allowedUDPPorts = [ 26504 ];
}
