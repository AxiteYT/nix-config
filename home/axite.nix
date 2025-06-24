{ pkgs, ... }:

{
  imports = [
    ./alacritty
    ./hyprland
    ./theming
  ];

  home = {
    username = "axite";
    homeDirectory = "/home/axite";
    stateVersion = "25.11";
  };
  programs.home-manager.enable = true;
}
