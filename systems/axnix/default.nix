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
    wireplumber = {
      enable = true;
      extraConfig."50-communication-roles.conf" = {
        "stream.roles" = [
          # WEBRTC VoiceEngine
          {
            matches = [
              {
                "application.name" = "WEBRTC VoiceEngine";
                "media.class" = "Stream/Output/Audio";
              }
            ];
            actions.update-props."media.role" = "Communication";
          }

          # Chromium/Chrome RTC fallback
          {
            matches = [
              {
                "application.name" = "Chromium";
                "media.name" = "~.*RTC.*";
              }
            ];
            actions.update-props."media.role" = "Communication";
          }

          # Native Discord binaries
          {
            matches = [
              {
                "application.name" = "Discord";
                "media.class" = "Stream/Output/Audio";
              }
              {
                "application.process.binary" = "Discord";
                "media.class" = "Stream/Output/Audio";
              }
              {
                "application.app-id" = "com.discordapp.Discord";
                "media.class" = "Stream/Output/Audio";
              }
            ];
            actions.update-props."media.role" = "Communication";
          }

          # Steam voice
          {
            matches = [
              { "application.name" = "Steam Voice Settings"; }
              {
                "application.name" = "Steam";
                "media.name" = "~.*Voice.*";
              }
            ];
            actions.update-props."media.role" = "Communication";
          }
        ];
      };
      extraConfig."61-media-role-ducking.conf" = {
        "wireplumber.settings" = {
          "node.stream.default-media-role" = "Multimedia";
          "linking.role-based.duck-level" = 0.3; # 0.3 = 30% of original volume
        };

        # Require the role loopbacks profile
        "wireplumber.profiles" = {
          main."policy.linking.role-based.loopbacks" = "required";
        };

        # Two role loopbacks: Multimedia (games/music) and Communication (calls)
        "wireplumber.components" = [
          {
            name = "libpipewire-module-loopback";
            type = "pw-module";
            arguments = {
              "node.name" = "loopback.role.multimedia";
              "node.description" = "Multimedia";
              "capture.props" = {
                "device.intended-roles" = [
                  "Music"
                  "Movie"
                  "Game"
                  "Multimedia"
                ];
                "policy.role-based.priority" = 10;
                "policy.role-based.action.same-priority" = "mix";
                "policy.role-based.action.lower-priority" = "mix";
              };
            };
            provides = "loopback.role.multimedia";
          }
          {
            name = "libpipewire-module-loopback";
            type = "pw-module";
            arguments = {
              "node.name" = "loopback.role.communication";
              "node.description" = "Communication";
              "capture.props" = {
                "device.intended-roles" = [
                  "Communication"
                  "Phone"
                ];
                "policy.role-based.priority" = 50;
                "policy.role-based.action.same-priority" = "mix";
                "policy.role-based.action.lower-priority" = "duck";
              };
            };
            provides = "loopback.role.communication";
          }
          {
            type = "virtual";
            provides = "policy.linking.role-based.loopbacks";
            requires = [
              "loopback.role.multimedia"
              "loopback.role.communication"
            ];
          }
        ];
      };
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
