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

  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = _: true;
    permittedInsecurePackages = [
      "ventoy-gtk3-1.1.05"
    ];
  };

  # Sops
  sops = {
    defaultSopsFile = (self + /secrets/secrets.yaml);
    defaultSopsFormat = "yaml";
    age.keyFile = "/home/axite/.config/sops/age/keys.txt";
    secrets.example-key = { };
  };

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
    gawk
    gitMinimal
    home-manager
    htop
    killall
    neofetch
    ookla-speedtest
    pciutils
    tmux
    tree
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

  # Set kernel to use latest Linux kernel
  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
}
