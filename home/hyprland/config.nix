let
  sharedLuaFiles = {
    "10-programs" = ''
      ---------------------
      ---- MY PROGRAMS ----
      ---------------------

      return {
          terminal = "ghostty",
          fileManager = "nautilus",
          menu = "wofi --show drun",
      }
    '';

    "30-env" = ''
      -------------------------------
      ---- ENVIRONMENT VARIABLES ----
      -------------------------------

      -- See https://wiki.hypr.land/configuring/core/environment-variables/
      hl.env("XCURSOR_SIZE", "20")
      hl.env("HYPRCURSOR_SIZE", "20")
    '';

    "40-look-and-feel" = ''
      -----------------------
      ---- LOOK AND FEEL ----
      -----------------------

      -- See https://wiki.hypr.land/configuring/core/config-options/
      hl.config({
          general = {
              gaps_in = 5,
              gaps_out = 3,
              border_size = 2,
              resize_on_border = false,
              allow_tearing = false,
              layout = "dwindle",
          },
          decoration = {
              rounding = 10,
              rounding_power = 2,
              active_opacity = 0.9,
              inactive_opacity = 0.82,
              shadow = {
                  enabled = true,
                  range = 4,
                  render_power = 3,
              },
              blur = {
                  enabled = true,
                  size = 8,
                  passes = 2,
                  vibrancy = 0.35,
              },
          },
          animations = {
              enabled = true,
          },
      })

      -- See https://wiki.hypr.land/configuring/core/animations/
      hl.curve("easeOutQuint", { type = "bezier", points = { {0.23, 1}, {0.32, 1} } })
      hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1} } })
      hl.curve("linear", { type = "bezier", points = { {0, 0}, {1, 1} } })
      hl.curve("almostLinear", { type = "bezier", points = { {0.5, 0.5}, {0.75, 1.0} } })
      hl.curve("quick", { type = "bezier", points = { {0.15, 0}, {0.1, 1} } })

      hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
      hl.animation({ leaf = "border", enabled = true, speed = 5.39, bezier = "easeOutQuint" })
      hl.animation({ leaf = "windows", enabled = true, speed = 4.79, bezier = "easeOutQuint" })
      hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.1, bezier = "easeOutQuint", style = "popin 87%" })
      hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.49, bezier = "linear", style = "popin 87%" })
      hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.73, bezier = "almostLinear" })
      hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.46, bezier = "almostLinear" })
      hl.animation({ leaf = "fade", enabled = true, speed = 3.03, bezier = "quick" })
      hl.animation({ leaf = "layers", enabled = true, speed = 3.81, bezier = "easeOutQuint" })
      hl.animation({ leaf = "layersIn", enabled = true, speed = 4, bezier = "easeOutQuint", style = "fade" })
      hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "linear", style = "fade" })
      hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.79, bezier = "almostLinear" })
      hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
      hl.animation({ leaf = "workspaces", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
      hl.animation({ leaf = "workspacesIn", enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade" })
      hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })

      -- See https://wiki.hypr.land/configuring/layouts/dwindle-layout/
      hl.config({
          dwindle = {
              preserve_split = true,
          },
      })

      -- See https://wiki.hypr.land/configuring/layouts/master-layout/
      hl.config({
          master = {
              new_status = "master",
          },
      })

      hl.config({
          misc = {
              force_default_wallpaper = 0,
              disable_hyprland_logo = true,
              disable_splash_rendering = true,
          },
          cursor = {
              no_hardware_cursors = 1,
          },
          ecosystem = {
              no_update_news = true,
          },
      })
    '';

    "50-input" = ''
      ---------------
      ---- INPUT ----
      ---------------

      -- See https://wiki.hypr.land/configuring/core/config-options/#input
      hl.config({
          input = {
              kb_layout = "us",
              kb_variant = "",
              kb_model = "",
              kb_options = "",
              kb_rules = "",
              follow_mouse = 1,
              sensitivity = 0,
              touchpad = {
                  natural_scroll = false,
              },
          },
      })

      -- See https://wiki.hypr.land/configuring/core/devices/
      hl.device({
          name = "epic-mouse-v1",
          sensitivity = -0.5,
      })
    '';

    "60-keybindings" = ''
      ---------------------
      ---- KEYBINDINGS ----
      ---------------------

      -- See https://wiki.hypr.land/configuring/core/binds/
      local programs = require("10-programs")
      local mainMod = "SUPER"

      hl.bind("XF86Calculator", hl.dsp.exec_cmd("gnome-calculator"))
      hl.bind("Print", hl.dsp.exec_cmd("sleep 1 && grim -t ppm - | satty --filename -"))

      hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd(programs.terminal))
      hl.bind(mainMod .. " + C", hl.dsp.window.close())
      hl.bind(mainMod .. " + M", hl.dsp.exit())
      hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(programs.fileManager))
      hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
      hl.bind(mainMod .. " + space", hl.dsp.exec_cmd(programs.menu))
      hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
      hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))
      hl.bind(mainMod .. " + K", hl.dsp.layout("swapsplit"))
      hl.bind(mainMod .. " + escape", hl.dsp.exec_cmd("pkill wleave || wleave -p layer-shell"))

      hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
      hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
      hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
      hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))

      for i = 1, 10 do
          local key = i % 10
          hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
          hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
      end

      hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
      hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

      hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
      hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

      hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
      hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

      hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
      hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
      hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true, repeating = true })
      hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true, repeating = true })
      hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
      hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

      hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
      hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
      hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
      hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
    '';

    "70-rules" = ''
      --------------------------------
      ---- WINDOWS AND WORKSPACES ----
      --------------------------------

      -- See https://wiki.hypr.land/configuring/core/rules/window-rules/
      hl.window_rule({
          name = "suppress-maximize-events",
          match = { class = ".*" },
          suppress_event = "maximize",
      })

      hl.window_rule({
          name = "fix-xwayland-drags",
          match = {
              class = "^$",
              title = "^$",
              xwayland = true,
              float = true,
              fullscreen = false,
              pin = false,
          },
          no_focus = true,
      })

      hl.window_rule({ match = { title = "^(.*Steam.*)$" }, workspace = "2" })
      hl.window_rule({ match = { title = "^(.*Discord.*)$" }, workspace = "3" })
      hl.window_rule({ match = { title = "^(.*OBS.*)$" }, workspace = "3" })

      hl.window_rule({
          match = { class = "hdos-Main" },
          no_blur = true,
          opacity = "1.0 override 1.0 override 1.0 override",
          force_rgbx = true,
      })

      hl.window_rule({
          match = { class = "net-runelite-client-RuneLite" },
          no_blur = true,
          opacity = "1.0 override 1.0 override 1.0 override",
          force_rgbx = true,
      })
    '';

    "80-gestures" = ''
      -- See https://wiki.hypr.land/configuring/core/gestures/
      hl.gesture({
          fingers = 3,
          direction = "horizontal",
          action = "workspace",
      })
    '';
  };

in
{
  inherit sharedLuaFiles;

  mkLuaFiles = monitorLua: { "00-monitors" = monitorLua; } // sharedLuaFiles;
}
