{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

let
  qbittorrentConfigFile = builtins.head config.systemd.services.qbittorrent.restartTriggers;
  qbittorrentPreStart = pkgs.writeShellScript "qbittorrent-pre-start" ''
    ${pkgs.coreutils}/bin/install -Dm600 ${qbittorrentConfigFile} \
      /var/lib/qBittorrent/qBittorrent/config/qBittorrent.conf

    QBT_PASSWORD_PBKDF2="$(${pkgs.coreutils}/bin/cat ${config.sops.secrets.BestaQB.path})" \
      ${pkgs.perl}/bin/perl -0pi -e 's/\@BestaQB\@/$ENV{QBT_PASSWORD_PBKDF2}/g' \
      /var/lib/qBittorrent/qBittorrent/config/qBittorrent.conf

    if ! ${pkgs.procps}/bin/pgrep -u qbittorrent -x qbittorrent-nox >/dev/null; then
      ${pkgs.coreutils}/bin/rm -f \
        /var/lib/qBittorrent/qBittorrent/config/lockfile \
        /var/lib/qBittorrent/qBittorrent/config/ipc-socket
    fi
  '';
in

{
  sops.secrets.BestaQB = {
    owner = "qbittorrent";
    group = "servarr";
    mode = "0400";
  };
  sops.secrets.BestaQuiPassword = {
    owner = "qbittorrent";
    group = "servarr";
    mode = "0400";
  };

  services.qbittorrent = {
    enable = true;
    openFirewall = false;
    user = "qbittorrent";
    group = "servarr";
    webuiPort = 8443;
    torrentingPort = 26504;
    extraArgs = [ "--confirm-legal-notice" ];
    serverConfig = {
      Application = {
        FileLogger = {
          Age = 1;
          AgeType = 1;
          Backup = true;
          DeleteOld = true;
          Enabled = true;
          MaxSizeBytes = 66560;
          Path = "/var/lib/qBittorrent/qBittorrent/config/qBittorrent/data/logs";
        };
        MemoryWorkingSetLimit = 8192;
      };

      BitTorrent.Session = {
        AddExtensionToIncompleteFiles = true;
        AddTrackersEnabled = false;
        AlternativeGlobalDLSpeedLimit = 0;
        AlternativeGlobalUPSpeedLimit = 0;
        AnonymousModeEnabled = false;
        BTProtocol = "TCP";
        BandwidthSchedulerEnabled = true;
        DefaultSavePath = "/media/Baitai/Downloads";
        DisableAutoTMMByDefault = false;
        DisableAutoTMMTriggers = {
          CategoryChanged = false;
          CategorySavePathChanged = false;
          DefaultSavePathChanged = false;
        };
        Encryption = 0;
        ExcludedFileNames = "";
        GlobalDLSpeedLimit = 1;
        GlobalMaxInactiveSeedingMinutes = -1;
        GlobalMaxRatio = -1;
        GlobalMaxSeedingMinutes = -1;
        GlobalUPSpeedLimit = 1;
        IgnoreLimitsOnLAN = false;
        IgnoreSlowTorrentsForQueueing = true;
        IncludeOverheadInLimits = false;
        MaxActiveCheckingTorrents = -1;
        MaxActiveDownloads = -1;
        MaxActiveTorrents = -1;
        MaxActiveUploads = -1;
        Port = 26504;
        Preallocation = false;
        QueueingSystemEnabled = false;
        SSL.Port = 17335;
        ShareLimitAction = "Stop";
        SlowTorrentsDownloadRate = 100;
        SubcategoriesEnabled = true;
        TempPath = "/media/Baitai/Downloads";
        TempPathEnabled = false;
        TorrentContentLayout = "Original";
        UseAlternativeGlobalSpeedLimit = false;
        UseCategoryPathsInManualMode = true;
        uTPRateLimited = true;
      };

      Core.AutoDeleteAddedTorrentFile = "Never";

      Meta = {
        LegalNotice.Accepted = true;
        MigrationVersion = 8;
      };

      Network = {
        Cookies = "@Invalid()";
        PortForwardingEnabled = false;
      };

      Preferences = {
        General.Locale = "en";
        MailNotification.req_auth = true;
        Scheduler = {
          days = "Weekday";
          end_time = "@Variant(\\0\\0\\0\\x0f\\x3n\\xe8\\0)";
          start_time = "@Variant(\\0\\0\\0\\x0f\\0\\0\\0\\0)";
        };
        WebUI = {
          Address = "127.0.0.1";
          LocalHostAuth = false;
          Password_PBKDF2 = "@BestaQB@";
          Port = 8443;
          Username = "besta";
        };
      };

      RSS.AutoDownloader = {
        DownloadRepacks = true;
        SmartEpisodeFilter = ''s(\\d+)e(\\d+), (\\d+)x(\\d+), "(\\d{4}[.\\-]\\d{1,2}[.\\-]\\d{1,2})", "(\\d{1,2}[.\\-]\\d{1,2}[.\\-]\\d{4})"'';
      };
    };
  };

  systemd.services.qbittorrent.serviceConfig.ExecStartPre = lib.mkForce qbittorrentPreStart;

  systemd.services.qui = {
    description = "qui for qBittorrent";
    after = [
      "network-online.target"
      "qbittorrent.service"
    ];
    wants = [ "network-online.target" ];
    requires = [ "qbittorrent.service" ];
    wantedBy = [ "multi-user.target" ];

    preStart = ''
      qui_password="$(cat ${config.sops.secrets.BestaQuiPassword.path})"

      for _ in $(${pkgs.coreutils}/bin/seq 1 60); do
        if ${pkgs.curl}/bin/curl --silent --output /dev/null --connect-timeout 1 http://127.0.0.1:8443/; then
          break
        fi

        ${pkgs.coreutils}/bin/sleep 1
      done

      ${pkgs.curl}/bin/curl --silent --fail --output /dev/null --connect-timeout 1 http://127.0.0.1:8443/

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
