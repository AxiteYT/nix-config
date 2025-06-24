{ pkgs, self, ... }:
{
  imports = [
    (self + /modules/actual)
    ./network-config.nix
  ];

  # Add actual user
  users = {
    users.actual = {
      isNormalUser = true;
      home = "/home/actual";
      description = "actual User";
      extraGroups = [
        "actual"
        "networkmanager"
        "wheel"
      ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINMXEwWst3Kkag14hG+nCtiRX8KHcn6w/rUeZC5Ww7RU axite@axitemedia.com"
      ];
    };
    groups.actual = {
      name = "actual";
    };
  };
  system.stateVersion = "25.11";
}
