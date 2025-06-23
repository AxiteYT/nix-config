{ pkgs, self, ... }:
{
  imports = [
    (self + /modules/actual)
    ./network-config.nix
  ];

  # Add actual user
  users.users.actualuser = {
    isNormalUser = true;
    home = "/home/actual";
    description = "actual User";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINMXEwWst3Kkag14hG+nCtiRX8KHcn6w/rUeZC5Ww7RU axite@axitemedia.com"
    ];
  };

  system.stateVersion = "25.11";
}
