{
  modulesPath,
  lib,
  pkgs,
  inputs,
  self,
  ...
}:
{
  # Import undetected modules
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    inputs.sops-nix.nixosModules.sops
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
      permittedInsecurePackages = [ "nexusmods-app-unfree-0.21.1" ];
    };
    overlays = [
      (final: prev: {
        runemate = prev.callPackage (self + /pkgs/runemate) { };
      })
    ];
  };

  # Sops
  sops = {
    defaultSopsFile = (self + /secrets/secrets.yaml);
    defaultSopsFormat = "yaml";
    age.keyFile = "/root/.config/sops/age/keys.txt";
    secrets.example-key = { };
  };

  systemd.tmpfiles.rules = [
    "d /root/.config/sops/age 0700 root root -"
  ];

  # Enable the Nix command and flakes
  nix.settings.experimental-features = [
    "flakes"
    "nix-command"
  ];

  # Add packages
  environment.systemPackages = with pkgs; [
    age
    alacritty
    btop
    curl
    dig
    dmidecode
    fastfetch
    gawk
    gitMinimal
    home-manager
    htop
    killall
    ookla-speedtest
    pciutils
    tmux
    tree
    unrar
    unzip
    wget
  ];

  # Set TimeZone
  time.timeZone = "Australia/Sydney";

  # Disable IPv6
  networking.enableIPv6 = false;

  networking = {
    # Domain
    domain = "axitemedia.com";
  };

  # Add axite user
  users.users.axite = {
    isNormalUser = true;
    description = "Kyle Smith";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  # Enable SSH
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINMXEwWst3Kkag14hG+nCtiRX8KHcn6w/rUeZC5Ww7RU axite@axitemedia.com"
  ];
  services.openssh.enable = true;

  # Allow all firmware
  hardware.enableAllFirmware = true;

  # Garbage Collection
  nix = {
    optimise = {
      automatic = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 8d";
    };
  };

  # Set kernel to use latest Linux kernel
  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
}
