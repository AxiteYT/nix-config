{ pkgs, ... }:

{
  imports = [
    ./alacritty
    ./brave
    ./btop
    ./codium
    ./desktop
    ./flameshot
    ./mimeapps
    ./pavucontrol
    ./hyprland
  ];

  home = {
    username = "axite";
    homeDirectory = "/home/axite";
    stateVersion = "25.11";
  };
  programs.home-manager.enable = true;
}
