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
    ./kernel.nix
    ./network-config.nix
  ];

  # Enable home-manager
  home-manager.users.axite = import (self + /home/axite.nix);

  # System Packages
  environment.systemPackages = with pkgs; [
    bitwarden
    blender
    bolt-launcher
    bottles
    brave
    cargo
    cifs-utils
    davinci-resolve
    discord
    dolphin-emu
    ffmpeg-full
    filezilla
    gh
    gimp
    git
    github-desktop
    gparted
    handbrake
    hunspell
    input-remapper
    k4dirstat
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
    patchelf
    piper
    powershell
    prismlauncher
    protontricks
    protonup-qt
    putty
    remmina
    rpcs3
    ryujinx
    spotify
    stress-ng
    unityhub
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
      obs-vaapi
      obs-vkcapture
      wlrobs
    ];
  };

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
