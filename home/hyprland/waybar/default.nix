{ config, ... }:
let
  colors = config.lib.stylix.colors;
  hex = c: "#${c}";
  hexa = a: c: "#${c}${a}";
  font = config.stylix.fonts.monospace.name;
in
{
  programs.waybar = {
    enable = true;
    style = ''
      :root {
        --bg: ${hexa "80" colors.base00};
        --bg-strong: ${hex colors.base00};
        --fg: ${hex colors.base06};
        --muted: ${hex colors.base03};
        --accent: ${hex colors.base0D};
        --accent-strong: ${hex colors.base0B};
        --panel-height: 32px;
      }

      * {
        border: none;
        border-radius: 0;
        font-family: "${font}", monospace;
        font-weight: bold;
        font-size: 14px;
        min-height: 0;
        color: var(--fg);
      }

      window#waybar {
        background-color: var(--bg);
        border-bottom: 2px solid ${hexa "80" colors.base02};
        transition: background-color 0.5s ease;
      }

      #workspaces button.active,
      #workspaces button.focused {
        color: var(--accent);
      }

      #tray menu {
        background-color: var(--bg-strong);
        border: 1px solid var(--accent);
        color: var(--fg);
        font-size: 14px;
        padding: 4px;
      }

      #tray menu menuitem:hover {
        background-color: var(--accent);
      }

      #custom-div {
        color: var(--muted);
      }
    '';
    settings = [
      {
        layer = "top";
        position = "top";
        mode = "dock";
        exclusive = true;
        passthrough = false;
        gtk-layer-shell = true;
        height = 0;
        modules-left = [
          "hyprland/workspaces"
          "custom/divider"
          "cpu"
          "custom/divider"
          "memory"
        ];
        modules-center = [ "hyprland/window" ];
        modules-right = [
          "tray"
          "custom/divider"
          "network"
          "custom/divider"
          "pulseaudio"
          "custom/divider"
          "clock"
        ];
        "hyprland/window" = {
          format = "{}";
          separate-outputs = true;
        };
        "hyprland/workspaces" = {
          on-scroll-up = "hyprctl dispatch workspace e+1";
          on-scroll-down = "hyprctl dispatch workspace e-1";
          all-outputs = true;
          on-click = "activate";
        };
        battery = {
          format = "󰁹 {}%";
        };
        cpu = {
          interval = 1;
          format = "󰻠 {}%";
          max-length = 10;
          on-click = "";
        };
        memory = {
          interval = 1;
          format = "  {}%";
          format-alt = " {used:0.1f}G";
          max-length = 10;
        };
        backlight = {
          format = "󰖨 {}";
          device = "acpi_video0";
        };
        tray = {
          icon-size = 13;
          tooltip = false;
          spacing = 10;
        };
        network = {
          format = "󰖩 {essid}";
          format-disconnected = "󰖪 disconnected";
        };
        clock = {
          format = " {:%I:%M:%S %p   %m/%d} ";
          interval = 1;
          tooltip-format = ''
            <big>{:%Y %B}</big>
            <tt><small>{calendar}</small></tt>'';
        };
        pulseaudio = {
          format = "{icon} {volume}%";
          tooltip = false;
          format-muted = " Muted";
          on-click = "pavucontrol";
          on-scroll-up = "pamixer -i 5";
          on-scroll-down = "pamixer -d 5";
          scroll-step = 5;
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = [
              ""
              ""
              ""
            ];
          };
        };
        "pulseaudio#microphone" = {
          format = "{format_source}";
          tooltip = false;
          format-source = " {volume}%";
          format-source-muted = " Muted";
          on-click = "pamixer --default-source -t";
          on-scroll-up = "pamixer --default-source -i 5";
          on-scroll-down = "pamixer --default-source -d 5";
          scroll-step = 5;
        };
        "custom/divider" = {
          format = " | ";
          interval = "once";
          tooltip = false;
        };
        "bluetooth" = {
          format = " 󰂯 ";
          tooltip = true;
          tooltip-format = "Bluetooth Settings";
          on-click = "blueman-applet";
        };
        "custom/endright" = {
          format = "_";
          interval = "once";
          tooltip = false;
        };
      }
    ];
  };
}
