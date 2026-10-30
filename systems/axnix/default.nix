{
  pkgs,
  lib,
  self,
  inputs,
  ...
}:
let
  pkgsStable = import inputs.nixpkgs-stable {
    system = pkgs.stdenv.hostPlatform.system;
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };
in
{
  imports = [
    (self + /hardware/amd)
    (self + /hardware/keychron)
    (self + /hardware/openrazer)
    (self + /systems/desktop)
    (self + /modules/steam)
    (self + /modules/artcraft)
    ./openrgb.nix
    ./kernel.nix
    ./network-config.nix
  ];

  nixpkgs.overlays = [
    (final: prev: {
      mcp-nixos = inputs.mcp-nixos.lib.mkMcpNixos {
        pkgs = final;
        # Upstream inspects mcp-types.version while choosing its MCP pair.
        # Anchor that inherited version to the unmodified package set to
        # avoid recursing through the scoped MCP override.
        python3Packages = prev.python3Packages.overrideScope (
          _: pyPrev: {
            mcp-types = pyPrev.mcp-types.override { mcp = prev.python3Packages.mcp; };
          }
        );
      };
    })
  ];

  # Enable home-manager
  home-manager = {
    users.axite = {
      imports = [
        (self + /home/axite.nix)
      ];
    };
  };

  # System Packages
  environment.systemPackages = with pkgs; [
    (pkgs.bottles.override { removeWarningPopup = true; })
    blender
    bolt-launcher
    cifs-utils
    codex
    # davinci-resolve-studio
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
    flameshot
    gh
    gimp
    git
    github-desktop
    glogg
    gparted
    handbrake
    input-remapper
    inputs.hytale-launcher.packages.${pkgs.stdenv.hostPlatform.system}.default
    mcp-nixos
    jellyfin-desktop
    qdirstat
    kdePackages.ark
    kdePackages.kdenlive
    killall
    pkgsStable.libreoffice
    lm_sensors
    lmstudio
    lutris
    nexusmods-app-unfree
    nixfmt
    nixpkgs-fmt
    nodejs
    ntfs3g
    obsidian
    openresolv
    p7zip
    patchelf
    piper
    postman
    powershell
    prismlauncher
    protonup-qt
    remmina
    pkgsStable.rpcs3
    ryubing
    spotify
    social-stream-ninja
    streamcontroller
    stress-ng
    unityhub
    vim
    vinegar
    virt-viewer
    wgnord
    winetricks
    wineWow64Packages.stable
    wineWow64Packages.waylandFull
    wireguard-tools
    xemu
    xdotool
    xprop
    xrandr
    xwininfo
    yad
  ];

  # Git
  programs.git = {
    enable = true;
    lfs.enable = true;
  };

  # Thunderbird
  programs.thunderbird = {
    enable = true;
  };

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

  # nix-ld
  programs.nix-ld = {
    enable = true;
  };

  # Virtualisation
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu.swtpm.enable = true;
    };
    spiceUSBRedirection.enable = true;
  };
  programs.virt-manager.enable = true;

  # Syncthing
  services.syncthing = {
    enable = true;

    user = "axite";
    group = "users";

    dataDir = "/home/axite/.local/state/syncthing";
    configDir = "/home/axite/.config/syncthing";

    openDefaultPorts = true;
  };

  # Enable ratbag daemon
  services.ratbagd.enable = true;

  # Ebavke Gnome keyring
  services.gnome.gnome-keyring.enable = true;

  # Open Razer
  users.users.axite.extraGroups = [ "openrazer" ];

  # Performance
  powerManagement.cpuFreqGovernor = "performance";
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 25;
  };

  services.scx = {
    enable = true;
    scheduler = "scx_lavd";
  };

  system.stateVersion = "25.11";
}
