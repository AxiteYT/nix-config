{
  description = "My personal flake config!";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "nixpkgs/nixos-unstable";

    # NixpkgsMaster
    pkgsMaster.url = "nixpkgs/master";

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

    # Catppuccin Theming
    catppuccin.url = "github:catppuccin/nix";
  };
  outputs =
    inputs@{
      self,
      nixpkgs,
      pkgsMaster,
      flake-utils,
      disko,
      home-manager,
      treefmt-nix,
      nixos-hardware,
      catppuccin,
      sops-nix,
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
      nixosConfigurations = {
        axnix = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [

            # Common system config
            ./systems/common

            # System specific config
            ./systems/axnix

            # Disko Setup
            disko.nixosModules.disko
            { disko.devices.disk.main.device = "/dev/nvme0n1"; }
            ./hardware/disk-config

            # Sops-nix
            sops-nix.nixosModules.sops

            # Home-manager
            home-manager.nixosModules.home-manager

            # Catppuccin Theming
            catppuccin.nixosModules.catppuccin

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

            # Sops-nix
            sops-nix.nixosModules.sops

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
        actual = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [

            # Common system config
            ./systems/common

            # Common server config
            ./systems/server

            # System specific config
            ./systems/actual

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
