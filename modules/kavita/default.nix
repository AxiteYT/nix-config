{ config, ... }:
let
  mediaPath = "/media/Baitai";
  kavitaPort = 5000;
in
{
  sops.secrets.BaitaiKavitaTokenKey = { };

  services.kavita = {
    enable = true;
    tokenKeyFile = config.sops.secrets.BaitaiKavitaTokenKey.path;
    settings = {
      Port = kavitaPort;
      IpAddresses = "0.0.0.0,::";
    };
  };

  users.groups.baitai = { };
  users.users.kavita.extraGroups = [ "baitai" ];

  systemd.services.kavita = {
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    unitConfig.RequiresMountsFor = mediaPath;
  };

  networking.firewall.allowedTCPPorts = [ kavitaPort ];
}
