{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    tdarr
  ];
}
