{
  pkgs,
  lib,
  self,
  inputs,
  ...
}:
{
  imports = [
    (self + /hardware/amd)
    (self + /hardware/keychron)
    (self + /modules/flatpak)
    (self + /modules/hyprland)
    (self + /modules/steam)
    (self + /systems/common/mounts/apollo.nix)
    ./kernel.nix
    ./network-config.nix
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
    (pkgs.bottles.override { removeWarningPopup = true; })
    blender
    bolt-launcher
    brave
    cifs-utils
    davinci-resolve
    discord
    discord-rpc
    dolphin-emu
    ffmpeg-full
    filezilla
    gh
    gimp
    git
    github-desktop
    glogg
    gnome-calculator
    gparted
    handbrake
    hunspell
    input-remapper
    k4dirstat
    kdePackages.ark
    killall
    libreoffice-qt
    lmstudio
    lutris
    neovim
    networkmanagerapplet
    nexusmods-app-unfree
    nixfmt
    nixpkgs-fmt
    nodejs
    ntfs3g
    obsidian
    ollama
    p7zip
    patchelf
    piper
    postman
    powershell
    prismlauncher
    protonup-qt
    remmina
    rpcs3
    runelite
    ryubing
    satty
    spotify
    streamcontroller
    stress-ng
    thunderbird
    unityhub
    vim
    virt-viewer
    vlc
    wayland-utils
    wgnord
    winetricks
    wineWowPackages.stable
    wineWowPackages.waylandFull
    xemu
    xdotool
    xorg.xprop
    xorg.xrandr
    xorg.xwininfo
    yad
  ];

  # OBS Config
  programs.obs-studio = {
    enable = true;
    package = pkgs.obs-studio;
    plugins = with pkgs.obs-studio-plugins; [
      obs-aitum-multistream
      obs-backgroundremoval
      obs-gstreamer
      obs-teleport
      obs-vaapi
      #todo: obs-vertical-canvas (currently broken)
      obs-vkcapture
      wlrobs
    ];
  };

  # VirtualBox Config
  virtualisation.virtualbox = {
    host = {
      enable = true;
      enableExtensionPack = true;
    };
  };
  users.extraGroups.vboxusers.members = [ "axite" ];

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
    pulseaudio.enable = false;
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

  # Enable ratbag daemon
  services.ratbagd.enable = true;

  system.stateVersion = "25.11";
}
