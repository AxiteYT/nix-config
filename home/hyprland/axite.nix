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
    extraLuaFiles =
      (hyprConfig.mkLuaFiles ''
        -- See https://wiki.hypr.land/configuring/core/monitors/
        hl.monitor({ output = "DP-1", mode = "2560x1440@240", position = "0x0", scale = 1, cm = "srgb" })
        hl.monitor({ output = "DP-2", mode = "2560x1440@60", position = "-2560x30", scale = 1 })
        hl.monitor({ output = "HDMI-A-1", mode = "2560x1440@60", position = "2560x-400", scale = 1, transform = 3 })
      '')
      // {
        "20-autostart" = ''
          -----------------
          ---- AUTOSTART ----
          -----------------

          -- See https://wiki.hypr.land/configuring/core/autostart/
          hl.on("hyprland.start", function()
              hl.exec_cmd("obs --startreplaybuffer")
              hl.exec_cmd("streamcontroller -b")
              hl.exec_cmd("waybar")
              hl.exec_cmd("steam")
              hl.exec_cmd("discord")
          end)
        '';
      };
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
