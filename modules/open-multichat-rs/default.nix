{
  config,
  lib,
  pkgs,
  utils,
  ...
}:
let
  cfg = config.services.open-multichat-rs;
  tomlFormat = pkgs.formats.toml { };
  generatedSettings = {
    port = 8787;
  }
  // cfg.settings;
  generatedConfig = tomlFormat.generate "open-multichat-rs.toml" generatedSettings;
  configPath = if cfg.configFile != null then cfg.configFile else generatedConfig;
  execArgs = [
    "${cfg.package}/bin/open-multichat-rs"
    "--config"
    "${configPath}"
  ]
  ++ cfg.extraArgs;
  execStart = utils.escapeSystemdExecArgs execArgs;
  firewallPort = if cfg.configFile == null then generatedSettings.port else cfg.firewallPort;
in
{
  options.services.open-multichat-rs = with lib; {
    enable = mkEnableOption "open-multichat-rs chat overlay server";

    package = mkOption {
      type = types.package;
      default = pkgs.open-multichat-rs;
      description = "The open-multichat-rs package to run.";
    };

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to open the configured port in the firewall.";
    };

    firewallPort = mkOption {
      type = types.nullOr types.port;
      default = null;
      description = ''
        Firewall port to open when using an external configFile.
        Leave unset when using settings so the port is derived from settings.port.
      '';
    };

    user = mkOption {
      type = types.str;
      default = "open-multichat-rs";
      description = "User account under which open-multichat-rs runs.";
    };

    group = mkOption {
      type = types.str;
      default = "open-multichat-rs";
      description = "Group under which open-multichat-rs runs.";
    };

    settings = mkOption {
      type = tomlFormat.type;
      default = { };
      description = ''
        Configuration written to a TOML file passed via --config.
        Uses the upstream defaults for any omitted keys.
      '';
      example = literalExpression ''
        {
          bind_address = "0.0.0.0";
          port = 8787;
          twitch_channels = [ "yourchannel" ];
          youtube_live_urls = [ "https://www.youtube.com/watch?v=VIDEO_ID" ];
          theme = {
            anchor_overlay = "left";
            anchor_dock = "left";
          };
        }
      '';
    };

    configFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = ''
        Path to an existing TOML config file. When set, settings are ignored.
      '';
    };

    extraArgs = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "Extra CLI arguments passed to open-multichat-rs.";
      example = [ "--dev-mode-mock" ];
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = !(cfg.openFirewall && firewallPort == null);
        message = "services.open-multichat-rs.openFirewall requires settings.port or firewallPort to be set.";
      }
    ];

    users.groups = lib.mkIf (cfg.group == "open-multichat-rs") {
      open-multichat-rs = { };
    };

    users.users = lib.mkIf (cfg.user == "open-multichat-rs") {
      open-multichat-rs = {
        isSystemUser = true;
        group = cfg.group;
      };
    };

    systemd.services.open-multichat-rs = {
      description = "Open MultiChat overlay server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        ExecStart = execStart;
        Restart = "on-failure";
        RestartSec = 5;
        NoNewPrivileges = true;
        PrivateTmp = true;
      };
    };

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ firewallPort ];
  };
}
