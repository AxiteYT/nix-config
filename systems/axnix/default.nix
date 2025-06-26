{
  pkgs,
  lib,
  self,
  inputs,
  catppuccin,
  ...
}:
let
  runemate = pkgs.callPackage (self + /pkgs/runemate) { };
in
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

  # Enable home-manager
  home-manager.users.axite = {
    imports = [
      (self + /home/axite.nix)
      inputs.catppuccin.homeModules.catppuccin
      {
        catppuccin = {
          enable = true;
          flavor = "mocha";
        };
      }
    ];
  };

  # qt theme
  qt.style = "adwaita-dark";

  # System Packages
  environment.systemPackages = with pkgs; [
    bitwarden
    blender
    bolt-launcher
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
    runemate
    ryujinx
    spotify
    stress-ng
    #TODO: (Uncomment once https://github.com/nixos/nixpkgs/issues/418451 is resolved):unityhub
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
      # obs-aitum-multistream
      obs-backgroundremoval
      obs-gstreamer
      obs-teleport
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
