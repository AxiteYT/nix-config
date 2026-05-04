{ pkgs, self, ... }:
{
  imports = [
    (self + /modules/kavita)
    (self + /modules/jellyfin)
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
  environment.systemPackages = with pkgs; [
    handbrake
    ffmpeg
  ];

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
