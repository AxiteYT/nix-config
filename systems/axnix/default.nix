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
    image = self + /home/hyprland/wallpapers/lake.jpg;
    polarity = "dark";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
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
        package = pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; };
        name = "FiraCode Nerd Font";
      };
      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
    };
    cursor = {
      package = pkgs.capitaine-cursors;
      name = "capitaine-cursors";
      size = 32;
    };
  };

  # Enable home-manager
  home-manager.users.axite = {
    imports = [
      (self + /home/axite.nix)
      inputs.stylix.homeManagerModules.stylix
    ];
  };

  # System Packages
  environment.systemPackages = with pkgs; [
    alsa-scarlett-gui
    bitwarden-desktop
    blender
    bolt-launcher
    bottles
    brave
    cargo
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
    protontricks
    protonup-qt
    runelite
    putty
    remmina
    rpcs3
    ryubing
    spotify
    stress-ng
    thunderbird
    unityhub
    ventoy-full-gtk
    vim
    virt-viewer
    vlc
    vscodium
    wayland-utils
    wgnord
    winetricks
    wineWowPackages.stable
    wineWowPackages.waylandFull
    xdotool
    xorg.xprop
    xorg.xrandr
    xorg.xwininfo
    yad
    zed-editor
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
      #todo: obs-vertical-canvas
      obs-vkcapture
      wlrobs
    ];
  };

  # VirtualBox
  virtualisation.virtualbox = {
    host = {
      enable = true;
      enableExtensionPack = true;
    };
  };
  users.extraGroups.vboxusers.members = [ "axite" ];

  # Enable sound
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    jack.enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
  };
  services.pulseaudio.enable = false;

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
