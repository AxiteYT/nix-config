{ pkgs, ... }:

{
  imports = [
    ./alacritty
    ./hyprland
    ./themes
  ];

  home = {
    username = "axite";
    homeDirectory = "/home/axite";
    stateVersion = "25.11";
  };
  programs.home-manager.enable = true;
}
