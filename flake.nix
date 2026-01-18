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
