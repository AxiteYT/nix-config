{
  config,
  lib,
  self,
  ...
}:
let
  colors = config.lib.stylix.colors;
  argb = alpha: color: "0x${alpha}${color}";
in
{
  imports = [
    (self + /home/waybar)
    (self + /home/wleave)
    (self + /home/wofi)
  ];
  wayland.windowManager.hyprland = {
    enable = true;
    systemd = {
      enable = true;
      variables = [ "--all" ];
    };
    xwayland.enable = true;
    extraConfig = (builtins.readFile ./hyprland.conf) + ''

      # Stylix palette overrides
      general {
          col.active_border = ${argb "ff" colors.base0D}
          col.inactive_border = ${argb "cc" colors.base03}
      }

      decoration {
          shadow {
              color = ${argb "ee" colors.base00}
          }
      }
    '';
  };

  # Wallpaper is handled by awww; keep hyprpaper disabled to avoid conflicts.
  services.hyprpaper.enable = lib.mkForce false;
}
