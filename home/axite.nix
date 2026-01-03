{ pkgs, ... }:

{
  imports = [
    ./alacritty
    ./btop
    ./brave
    ./codium
    ./flameshot
    ./mimeapps
    ./pavucontrol
    ./hyprland
  ];

  home = {
    username = "axite";
    homeDirectory = "/home/axite";
    stateVersion = "25.11";

    file.".config/kwalletrc".text = ''
      [Wallet]
      Enabled=false
    '';
  };
  programs.home-manager.enable = true;
}
