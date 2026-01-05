{ self, inputs, pkgs, ... }:
{
  imports = [
    inputs.home-manager.darwinModules.home-manager
  ];

  nixpkgs = {
    hostPlatform = "aarch64-darwin";
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  nix.settings.experimental-features = [
    "flakes"
    "nix-command"
  ];

  services.nix-daemon.enable = true;

  programs.zsh.enable = true;
  environment.shells = [ pkgs.zsh pkgs.bashInteractive ];

  users.users.axite = {
    name = "axite";
    home = "/Users/axite";
    description = "Kyle Smith";
    shell = pkgs.zsh;
  };

  security.pam.enableSudoTouchIdAuth = true;

  environment.systemPackages = with pkgs; [
    git
    home-manager
    nixfmt
    ripgrep
    tree
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs self; };
    users.axite = import ../../home/axite-darwin.nix;
  };

  system.stateVersion = 4;
}
