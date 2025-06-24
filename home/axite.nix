{ pkgs, ... }:

{
  imports = [
    ./alacritty
    ./hyprland
    ./themes
    catppuccin.homeManagerModules.catppuccin
  ];

  home = {
    username = "axite";
    homeDirectory = "/home/axite";
    stateVersion = "25.11";
  };
  programs.home-manager.enable = true;
}
