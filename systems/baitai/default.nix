{ pkgs, self, ... }:
{
  imports = [
    (self + /modules/jellyfin)
    #(self + /modules/plex)
    (self + /systems/common/mounts/baitai.nix)
    ./network-config.nix
  ];

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      intel-compute-runtime
    ];
  };

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";
  };

  systemd.services.jellyfin.environment = {
    LIBVA_DRIVER_NAME = "iHD";
  };

  hardware.intel-gpu-tools.enable = true;

  # Add handbrake
  environment.systemPackages = with pkgs; [ handbrake ];

  /*
  # Add plex user
  users.users.plexuser = {
    isNormalUser = true;
    home = "/home/plex";
    description = "Plex User";
    extraGroups = [
      "networkmanager"
      "plex"
      "wheel"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINMXEwWst3Kkag14hG+nCtiRX8KHcn6w/rUeZC5Ww7RU axite@axitemedia.com"
    ];
  };
  */

    users.users.baitai = {
    isNormalUser = true;
    home = "/home/baitai";
    description = "Baitai User";
    extraGroups = [
      "networkmanager"
      "baitai"
      "wheel"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINMXEwWst3Kkag14hG+nCtiRX8KHcn6w/rUeZC5Ww7RU axite@axitemedia.com"
    ];
  };

  system.stateVersion = "25.11";
}
