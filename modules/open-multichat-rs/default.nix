{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.open-multichat-rs;
  tomlFormat = pkgs.formats.toml { };
  generatedConfig = tomlFormat.generate "open-multichat-rs.toml" cfg.settings;
  configPath = if cfg.configFile != null then cfg.configFile else generatedConfig;
  execArgs = [
    "${cfg.package}/bin/open-multichat-rs"
    "--config"
    "${configPath}"
  ]
  ++ cfg.extraArgs;
  execStart = lib.concatStringsSep " " execArgs;
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

    port = mkOption {
      type = types.port;
      default = 8787;
      description = "Port used for firewall rules when openFirewall is enabled.";
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

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ cfg.port ];
  };
}
