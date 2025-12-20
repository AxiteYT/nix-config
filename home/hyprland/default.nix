{ ... }:
{
  imports = [
    ./waybar
    ./wofi
    ./wlogout
  ];
  wayland.windowManager.hyprland = {
    enable = true;
    systemd = {
      enable = true;
      variables = [ "--all" ];
    };
    xwayland.enable = true;
    extraConfig = builtins.readFile ./hyprland.conf;
  };
}
