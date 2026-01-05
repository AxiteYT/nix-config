{ pkgs, ... }:
{
  imports = [
    ./alacritty
    ./btop
  ];

  home = {
    username = "axite";
    homeDirectory = "/Users/axite";
    stateVersion = "25.11";
  };

  programs.home-manager.enable = true;
}
