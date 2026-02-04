{
  description = "My personal flake config!";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "nixpkgs/nixos-unstable";

    # Flake utils
    flake-utils.url = "github:numtide/flake-utils";

    # Hardware
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # Disko
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # SOPS
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Home-Manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Treefmt
    treefmt-nix.url = "github:numtide/treefmt-nix";

    # Nix Darwin
    nix-darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Stylix theming
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # awww wallpaper daemon
    awww.url = "git+https://codeberg.org/LGFae/awww";

    # CachyOS Kernel
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";

    # HytaleLauncherFlake
    hytale-launcher.url = "github:TNAZEP/HytaleLauncherFlake";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      flake-utils,
      disko,
      home-manager,
      hytale-launcher,
      treefmt-nix,
      nix-cachyos-kernel,
      nixos-hardware,
      stylix,
      sops-nix,
      nix-darwin,
      ...
    }:

    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        lib = nixpkgs.lib;

        fmtcfg = {
          projectRootFile = "flake.nix";
          programs = {
            nixfmt.enable = true;
            prettier.enable = true;
            shfmt.enable = true;
          };
        };

        treefmtEval = inputs.treefmt-nix.lib.evalModule pkgs fmtcfg;
      in
      {
        formatter = treefmtEval.config.build.wrapper;
      }
      // lib.optionalAttrs (system == "x86_64-linux") {
        # Bootable ISO built from nixpkgs/unstable using the latest kernel
        packages.bootable-iso =
          (nixpkgs.lib.nixosSystem {
            inherit system;
            modules = [
              (
                { modulesPath, lib, ... }:
                {
                  imports = [
                    (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix")
                  ];

                  # Ensure the ISO uses the newest available kernel
                  boot.kernelPackages = pkgs.linuxPackages_latest;
                  # Drop ZFS to avoid broken module on newest kernels
                  boot.supportedFilesystems = lib.mkForce [
                    "btrfs"
                    "ext4"
                    "f2fs"
                    "xfs"
                    "vfat"
                  ];

                  # SSH access for installer: enable sshd and allow root key auth with existing key
                  services.openssh = {
                    enable = true;
                    settings = {
                      PermitRootLogin = "prohibit-password";
                      PasswordAuthentication = false;
                    };
                  };
                  users.users.root.openssh.authorizedKeys.keys = [
                    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINMXEwWst3Kkag14hG+nCtiRX8KHcn6w/rUeZC5Ww7RU axite@axitemedia.com"
                  ];

                  # Make flake/Nix command available inside the installer environment
                  nix.settings.experimental-features = [
                    "flakes"
                    "nix-command"
                  ];
                }
              )
            ];
            specialArgs = { inherit self inputs; };
          }).config.system.build.isoImage;
      }
    )
    // {
      # Overlays

      # Systems
      darwinConfigurations = {
        axdarwin = nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = { inherit self inputs; };
          modules = [
            ./systems/darwin/axdarwin.nix
          ];
        };
      };
      nixosConfigurations = {
        axnix = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [

            # Common system config
            ./systems/common

            # System specific config
            ./systems/axnix
            stylix.nixosModules.stylix

            # Disko Setup
            disko.nixosModules.disko
            { disko.devices.disk.main.device = "/dev/nvme0n1"; }
            ./hardware/disk-config

            # Home-manager
            home-manager.nixosModules.home-manager
          ];
          specialArgs = { inherit self inputs; };
        };
        besta = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [

            # Common system config
            ./systems/common

            # Common server config
            ./systems/server

            # System specific config
            ./systems/besta

            # Disko Setup
            disko.nixosModules.disko
            ./hardware/disk-config

            # Home-manager
            home-manager.nixosModules.home-manager
          ];
          specialArgs = { inherit self inputs; };
        };
        plex = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [

            # Common system config
            ./systems/common

            # Common server config
            ./systems/server

            # System specific config
            ./systems/plex

            # Disko Setup
            disko.nixosModules.disko
            ./hardware/disk-config

            # Home-manager
            home-manager.nixosModules.home-manager
          ];
          specialArgs = { inherit self inputs; };
        };
      };
    };
}
