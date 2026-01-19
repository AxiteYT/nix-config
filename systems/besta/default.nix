{ pkgs, self, ... }:
{
  imports = [
    (self + /modules/servarr)
    (self + /systems/common/mounts/plex.nix)
    ./network-config.nix
  ];

  environment.systemPackages = with pkgs; [ ffmpeg ];

  # Add besta user
  users.users.besta = {
    isNormalUser = true;
    home = "/home/besta";
    description = "Besta User";
    autoSubUidGidRange = true;
    linger = true;
    extraGroups = [
      "networkmanager"
      "servarr"
      "wheel"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINMXEwWst3Kkag14hG+nCtiRX8KHcn6w/rUeZC5Ww7RU axite@axitemedia.com"
    ];
  };

  system.stateVersion = "25.11";
}
