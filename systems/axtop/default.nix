{
  pkgs,
  lib,
  self,
  inputs,
  ...
}:
{
  imports = [
    (self + /modules/flatpak)
    (self + /modules/hyprland)
    (self + /modules/steam)
    ./network-config.nix
    ./kernel.nix
  ];

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
      package = pkgs.capitaine-cursors;
      name = "capitaine-cursors";
      size = 32;
    };
  };

  # Ensure Qt apps (Dolphin, etc.) pick up the Stylix/Kvantum theme
  environment.sessionVariables.QT_STYLE_OVERRIDE = "kvantum";

  # Enable home-manager
  home-manager = {
    users.axite = {
      imports = [
        (self + /home/axite.nix)
      ];
    };
    backupFileExtension = "hm-bak";
    overwriteBackup = true;
  };

  # System Packages
  environment.systemPackages = with pkgs; [
    bolt-launcher
    brave
    discord
    discord-rpc
    (pkgs.ffmpeg-full.override {
      withUnfree = true;
      withVaapi = true;
      withDrm = true;
      withAmf = true;
      withOpencl = true;
      withVulkan = true;
    })
    filezilla
    firefox
    flameshot
    gh
    gimp
    git
    github-desktop
    glogg
    gnome-calculator
    gparted
    grim
    handbrake
    hunspell
    input-remapper
    inputs.hytale-launcher.packages.${pkgs.system}.default
    k4dirstat
    kdePackages.ark
    killall
    libreoffice-qt
    lutris
    networkmanagerapplet
    nixfmt
    nixpkgs-fmt
    obsidian
    p7zip
    patchelf
    piper
    postman
    powershell
    prismlauncher
    protonup-qt
    pulseaudioFull
    remmina
    spotify
    thunderbird
    vim
    virt-viewer
    vlc
    wayland-utils
    wgnord
    winetricks
    wineWowPackages.stable
    wineWowPackages.waylandFull
    xorg.xprop
    xorg.xrandr
    xorg.xwininfo
    yad
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

  system.stateVersion = "25.11";
}
