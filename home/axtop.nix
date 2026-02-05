{ pkgs, ... }:

{
  imports = [
    ./btop
    ./brave
    ./codium
    ./mimeapps
    ./pavucontrol
    ./hyprland/axtop.nix
    ./satty
    ./zsh
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
  # Enable XDG support so desktop entries are placed in ~/.local/share/applications.
  xdg.enable = true;
}
