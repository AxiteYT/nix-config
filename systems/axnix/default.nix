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
    kdePackages.kdenlive
    killall
    libreoffice-qt
    lm_sensors
    lmstudio
    lutris
    networkmanagerapplet
    nexusmods-app-unfree
    nixfmt
    nixpkgs-fmt
    nodejs
    ntfs3g
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
    rpcs3
    ryubing
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
    enableVirtualCamera = true;
    package = pkgs.symlinkJoin {
      name = "obs-studio-xwayland";
      paths = [ pkgs.obs-studio ];
      nativeBuildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/obs --set QT_QPA_PLATFORM xcb
      '';
    };
    plugins = with pkgs.obs-studio-plugins; [
      obs-aitum-multistream
      obs-backgroundremoval
      obs-gstreamer
      obs-teleport
      obs-vaapi
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
    pulseaudio = {
      enable = false;
      package = pkgs.pulseaudioFull;
    };
    udev.extraRules = ''
      ACTION=="add", SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", \
        ATTRS{idVendor}=="0fd9", ATTRS{idProduct}=="0084", \
        TAG+="systemd", ENV{SYSTEMD_WANTS}="elgato-xlr-kick.service"
    '';
  };
  systemd.services.elgato-xlr-kick = {
    description = "Restart PipeWire/WirePlumber on Elgato XLR Dock hotplug";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.util-linux}/bin/runuser -u axite -- ${pkgs.bash}/bin/bash -lc 'XDG_RUNTIME_DIR=/run/user/1000 ${pkgs.systemd}/bin/systemctl --user restart pipewire wireplumber pipewire-pulse'";
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

  # Enable ratbag daemon
  services.ratbagd.enable = true;

  # Enable open-rgb
  services.hardware.openrgb = {
    enable = true;
    package = pkgs.openrgb-with-all-plugins;
    motherboard = "amd";
  };

  system.stateVersion = "25.11";
}
