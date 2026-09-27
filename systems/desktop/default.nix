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
    base16Scheme = "${pkgs.base16-schemes}/share/themes/onedark.yaml";
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
