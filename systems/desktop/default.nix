{ pkgs, ... }:
{
  imports = [
    ../../modules/flatpak
    ../../modules/hyprland
  ];

  # Stylix
  stylix = {
    enable = true;
    polarity = "dark";
    # One Dark from base16-schemes. Keep the palette directly evaluable:
    # flake check --no-build cannot read a scheme from an unbuilt package.
    base16Scheme = {
      base00 = "282c34";
      base01 = "353b45";
      base02 = "3e4451";
      base03 = "545862";
      base04 = "565c64";
      base05 = "abb2bf";
      base06 = "b6bdca";
      base07 = "c8ccd4";
      base08 = "e06c75";
      base09 = "d19a66";
      base0A = "e5c07b";
      base0B = "98c379";
      base0C = "56b6c2";
      base0D = "61afef";
      base0E = "c678dd";
      base0F = "be5046";
    };
    fonts = {
      serif = {
        package = pkgs.noto-fonts;
        name = "Noto Serif";
      };
      sansSerif = {
        package = pkgs.noto-fonts;
        name = "Noto Sans";
      };
      monospace = {
        package = pkgs.nerd-fonts.fira-code;
        name = "FiraCode Nerd Font";
      };
      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };
    };
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 20;
    };
  };

  # Ensure Qt apps (Dolphin, etc.) pick up the Stylix/Kvantum theme
  environment.sessionVariables.QT_STYLE_OVERRIDE = "kvantum";

  home-manager = {
    backupFileExtension = "hm-bak";
    overwriteBackup = true;
  };

  environment.systemPackages = with pkgs; [
    brave
    firefox
    gnome-calculator
    grim
    hunspell
    networkmanagerapplet
    pulseaudioFull
    vlc
    wayland-utils
  ];

  # Enable sound
  security.rtkit.enable = true;

  services = {
    pipewire = {
      enable = true;
      wireplumber = {
        enable = true;
      };
      pulse.enable = true;
      jack.enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
    };
    pulseaudio = {
      enable = false;
      package = pkgs.pulseaudioFull;
    };
  };

  # Enable Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Experimental = true;
      };
    };
  };
}
