{ pkgs, self, ... }:
{
  imports = [
    (self + /modules/actual)
    ./network-config.nix
  ];
  
  system.stateVersion = "25.11";
}
