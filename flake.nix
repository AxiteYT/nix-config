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

    # Home-Manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Treefmt
    treefmt-nix.url = "github:numtide/treefmt-nix";
  };
  outputs =
    inputs@{
      self,
      nixpkgs,
      flake-utils,
      disko,
      home-manager,
      treefmt-nix,
      nixos-hardware,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };

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
        acr = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [

            # Common system config
            ./systems/common

            # System specific config
            ./systems/acr

            # Disko Setup
            disko.nixosModules.disko
            { disko.devices.disk.main.device = "/dev/nvme0n1"; }
            ./hardware/disk-config

            # Hardware
            nixos-hardware.nixosModules.dell-latitude-7430

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
