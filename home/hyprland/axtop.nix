{
  config,
  lib,
  ...
}:
let
  colors = config.lib.stylix.colors;
  argb = alpha: color: "0x${alpha}${color}";
in
{
  imports = [
    ../waybar
    ../wleave
    ../wofi
  ];

  xdg.configFile = {
    "hypr/conf.d/00-monitors.conf".source = ./conf.d/monitors/axtop.conf;
    "hypr/conf.d/10-programs.conf".source = ./conf.d/10-programs.conf;
    "hypr/conf.d/20-autostart.conf".source = ./conf.d/20-autostart.conf;
    "hypr/conf.d/30-env.conf".source = ./conf.d/30-env.conf;
    "hypr/conf.d/40-look-and-feel.conf".source = ./conf.d/40-look-and-feel.conf;
    "hypr/conf.d/50-input.conf".source = ./conf.d/50-input.conf;
    "hypr/conf.d/60-keybindings.conf".source = ./conf.d/60-keybindings.conf;
    "hypr/conf.d/70-rules.conf".source = ./conf.d/70-rules.conf;
  };

  wayland.windowManager.hyprland = {
    enable = true;
    systemd = {
      enable = true;
      variables = [ "--all" ];
    };
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
