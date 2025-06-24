{ pkgs, self, ... }:
{
  imports = [
    (self + /modules/actual)
    ./network-config.nix
  ];

  users = {
    users.actual = {
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINMXEwWst3Kkag14hG+nCtiRX8KHcn6w/rUeZC5Ww7RU axite@axitemedia.com"
      ];
      isSystemUser = true;
      group = "actual";
      home = "/actual";
      createHome = true;
      homeMode = "755";
    };
    groups.actual = { };
  };
  system.stateVersion = "25.11";
}
