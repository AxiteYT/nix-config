{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    pavucontrol
    pamixer
  ];
}
