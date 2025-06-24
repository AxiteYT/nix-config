{ pkgs, lib, ... }:
{
  services.flatpak.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = lib.mkForce (with pkgs; [ xdg-desktop-portal-hyprland ]);
  };
}
