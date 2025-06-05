{ pkgs, lib, ... }:
{
  imports = [ ./default.nix ];

  # Set to stable kernel
  boot.kernelPackages = lib.mkForce pkgs.linuxPackages_6_11;

  services = {
    xserver = {
      enable = true;
      displayManager = {
        lightdm.enable = false;
        gdm.enable = true;
      };
    };
    displayManager = {
      autoLogin = {
        enable = true;
        user = "dojo";
      };
    };
  };
  programs.steam.gamescopeSession.enable = true;
  programs.gamescope.enable = true;

  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;
}
