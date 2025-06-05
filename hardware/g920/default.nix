{ pkgs, lib, ... }:
{
  # Source: https://github.com/the-furry-hubofeverything/hubble-systems/blob/main/hosts/pc/common/hardware/logitechWheelSupport.nix

  # steering wheel driver
  hardware.new-lg4ff.enable = true;

  # Xbox controller driver
  hardware.xpadneo.enable = true;

  # G920 etc. support
  environment.etc = {
    # Creates /etc/usb_modeswitch.d/046d:c261
    "usb_modeswitch.d/046d:c261" = {
      text = ''
        # Logitech G920 Racing Wheel
        DefaultVendor=046d
        DefaultProduct=c261
        MessageEndpoint=01
        ResponseEndpoint=01
        TargetClass=0x03
        MessageContent="0f00010142"
      '';
    };
  };

  # udev rules
  services.udev.extraRules = ''
    ATTR{idVendor}=="046d", ATTR{idProduct}=="c261", RUN+="${pkgs.usb-modeswitch}/bin/usb_modeswitch -c '/etc/usb_modeswitch.d/046d:c261'"
  '';

  # Install neccesary packages
  environment.systemPackages = with pkgs; [
    oversteer
    usb-modeswitch
    usb-modeswitch-data
  ];
}
