{
  config,
  lib,
  ...
}:
let
  colors = config.lib.stylix.colors;
  argb = alpha: color: "0x${alpha}${color}";
  hyprConfig = import ./config.nix;
in
{
  imports = [
    ../waybar
    ../wleave
    ../wofi
  ];

  xdg.configFile = hyprConfig.mkConfigFiles hyprConfig.monitors.axtop;

  wayland.windowManager.hyprland = {
    enable = true;
    systemd = {
      enable = true;
      variables = [ "--all" ];
    };
    extraConfig = hyprConfig.mainConfig + ''

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

  services.hyprpaper.enable = lib.mkForce false;
}
