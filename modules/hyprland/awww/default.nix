{
  pkgs,
  inputs,
  lib,
  ...
}:
{
  environment.systemPackages = [
    inputs.awww.packages.${pkgs.stdenv.hostPlatform.system}.awww
  ];
}
