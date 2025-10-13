{ pkgs, self, ... }:

let
  tdarrnode = pkgs.callPackage (self + /pkgs/tdarr/node.nix) { };
  tdarrpackage = pkgs.callPackage (self + /pkgs/tdarr/package.nix) { };
  tdarrserver = pkgs.callPackage (self + /pkgs/tdarr/server.nix) { };
in
{
  environment.systemPackages = with pkgs; [
    tdarrnode
    tdarrpackage
    tdarrserver
  ];
}
