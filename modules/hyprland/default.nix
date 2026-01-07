{ pkgs, ... }:
{
  imports = [
    ./awww
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
    hyprls
    kitty
    nautilus
    nwg-look
    waybar
    wofi
  ];

  # Enable open terminal in nautilus
  programs.nautilus-open-any-terminal = {
    enable = true;
    terminal = "alacritty";
  };

  # Enable trash for nautilus
  services.gvfs.enable = true;

  # Enable sushi for nautilus
  services.gnome.sushi.enable = true;

  # Fonts
  fonts = {
    packages = with pkgs; [
      fira-code
      fira-code-symbols
      font-awesome
      hunspellDicts.en_AU
      hunspellDicts.en_US
      nerd-fonts.meslo-lg
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      source-han-sans
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
