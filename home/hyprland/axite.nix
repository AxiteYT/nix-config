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
    ../../modules/hyprland/swaync
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    configType = "lua";
    extraLuaFiles = hyprConfig.mkLuaFiles hyprConfig.monitors.axnix;
    systemd = {
      enable = true;
      variables = [ "--all" ];
    };
    extraConfig = ''
      -- Stylix palette overrides
      hl.config({
          general = {
              col = {
                  active_border = ${argb "ff" colors.base0D},
                  inactive_border = ${argb "cc" colors.base03},
              },
          },
          decoration = {
              shadow = {
                  color = ${argb "ee" colors.base00},
              },
          },
      })
    '';
  };

  services.hyprpaper.enable = lib.mkForce false;
}
