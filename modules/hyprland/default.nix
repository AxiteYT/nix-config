{ pkgs, ... }:
{
  imports = [
    ./greetd
    ./waybar
  ];

  # Enable hyprland
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  # Set electron apps to use hyprland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Hyprland related packages
  environment.systemPackages = with pkgs; [
    kdePackages.dolphin
    hyprls
    kitty
    nwg-look
    waybar
    wofi
  ];

  # Fonts
  fonts = {
    packages = with pkgs; [
      fira-code
      fira-code-symbols
      font-awesome
      hunspellDicts.en_AU
      hunspellDicts.en_US
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      source-han-sans
      source-han-sans-japanese
      source-han-serif-japanese
      nerd-fonts.meslo-lg
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [ "Meslo LG M Regular Nerd Font Complete Mono" ];
        serif = [
          "Noto Serif"
          "Source Han Serif"
        ];
        sansSerif = [
          "Noto Sans"
          "Source Han Sans"
        ];
      };
    };
  };

  # Needed for gparted
  security.polkit.enable = true;
}
