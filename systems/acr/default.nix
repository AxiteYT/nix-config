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
    ./kernel.nix
    ./network-config.nix
  ];

  # Enable home-manager
  home-manager.users.axite = import (self + /home/axite.nix);

  # System Packages
  environment.systemPackages = with pkgs; [
    bitwarden
    bottles
    brave
    cargo
    cifs-utils
    ffmpeg-full
    filezilla
    gh
    gimp
    git
    github-desktop
    gparted
    k4dirstat
    killall
    libreoffice-qt
    neovim
    networkmanagerapplet
    nixfmt
    nixpkgs-fmt
    nodejs
    ntfs3g
    obsidian
    powershell
    putty
    remmina
    spotify
    stress-ng
    vim
    virt-viewer
    vlc
    vscodium
    wayland-utils
    xdotool
    xorg.xprop
    xorg.xrandr
    xorg.xwininfo
  ];

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
