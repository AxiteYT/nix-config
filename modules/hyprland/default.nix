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
      nerd-fonts.fira-code
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      source-han-sans
      unifont
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [
          "FiraCode Nerd Font Mono"
          "FiraCode Nerd Font"
          "Noto Sans Mono"
          "Noto Sans Symbols 2"
          "Noto Color Emoji"
        ];
        serif = [
          "Noto Serif"
          "Noto Sans Symbols 2"
          "Noto Color Emoji"
          "Source Han Serif"
        ];
        sansSerif = [
          "Noto Sans"
          "Noto Sans Symbols 2"
          "Noto Color Emoji"
          "Source Han Sans"
        ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };

  # Needed for gparted
  security.polkit.enable = true;
}
