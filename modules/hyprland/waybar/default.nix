{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    pavucontrol
    pamixer
  ];

  # Bluetooth applet
  services.blueman.enable = true;
}
