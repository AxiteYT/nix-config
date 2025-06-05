# treefmt.nix
{ pkgs, ... }:

{
  projectRootFile = "flake.nix";

  programs = {
    nixfmt.enable = true;
    prettier.enable = true;
    shfmt.enable = true;
  };
}
