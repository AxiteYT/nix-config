{
  description = "My personal flake config!";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "nixpkgs/nixos-unstable";

    # Flake utils
    flake-utils.url = "github:numtide/flake-utils";

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
      };
    };
}
