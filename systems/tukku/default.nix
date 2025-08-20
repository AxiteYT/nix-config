{ pkgs, self, ... }:
{
  imports = [
    (self + /modules/rustdesk)
    ./network-config.nix
  ];

  # Add tukku user
  users.users.tukkuuser = {
    isNormalUser = true;
    home = "/home/tukku";
    description = "tukku User";
    extraGroups = [
      "networkmanager"
      "tukku"
      "wheel"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINMXEwWst3Kkag14hG+nCtiRX8KHcn6w/rUeZC5Ww7RU axite@axitemedia.com"
    ];
  };

  system.stateVersion = "25.11";
}
