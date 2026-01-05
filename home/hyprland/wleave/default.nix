{ pkgs, config, ... }:
let
  colors = config.lib.stylix.colors;
  hex = c: "#${c}";
  hexa = alpha: color: "#${color}${alpha}";
  font = config.stylix.fonts.sansSerif.name;
  monoFont = config.stylix.fonts.monospace.name;
  wleavePkg = config.programs.wleave.package or pkgs.wleave;
in
{
  programs.wleave = {
    enable = true;
    style = ''
      window {
        background-color: ${hexa "d8" colors.base00};
        font-family: "${font}", sans-serif;
        --window-bg-color: ${hexa "f2" colors.base00};
        --view-bg-color: ${hexa "eb" colors.base01};
        --view-fg-color: ${hex colors.base06};
        --accent-color: ${hex colors.base0D};
        --accent-bg-color: ${hex colors.base0D};
        --accent-fg-color: ${hex colors.base07};
      }

      button {
        color: var(--view-fg-color);
        background-color: var(--view-bg-color);
        border: 1px solid ${hexa "40" colors.base03};
        border-radius: 18px;
        padding: 16px 22px;
        box-shadow: 0 12px 30px -20px ${hexa "99" colors.base00};
        transition: all 120ms ease;
      }

      button label.action-name {
        font-size: 1.1rem;
        letter-spacing: 0.04em;
      }

      button label.keybind {
        font-size: 0.95rem;
        font-family: "${monoFont}", monospace;
        opacity: 0.75;
      }

      button:hover label.keybind,
      button:focus label.keybind {
        opacity: 1;
      }

      button:focus,
      button:hover {
        background-color: color-mix(in srgb, var(--accent-bg-color) 15%, var(--view-bg-color));
        border-color: ${hexa "7f" colors.base0D};
        color: var(--accent-color);
      }

      button:active {
        background-color: var(--accent-bg-color);
        color: var(--accent-fg-color);
        transform: translateY(1px);
        box-shadow: 0 8px 20px -14px ${hexa "b3" colors.base00};
      }
    '';
    settings = {
      no-version-info = true;
      buttons = [
        {
          label = "shutdown";
          action = "systemctl poweroff";
          text = "Shutdown";
          keybind = "p";
          icon = "${wleavePkg}/share/wleave/icons/shutdown.svg";
        }
        {
          label = "reboot";
          action = "systemctl reboot";
          text = "Reboot";
          keybind = "r";
          icon = "${wleavePkg}/share/wleave/icons/reboot.svg";
        }
        {
          label = "logout";
          action = "hyprctl dispatch exit";
          text = "Logout";
          keybind = "e";
          icon = "${wleavePkg}/share/wleave/icons/logout.svg";
        }
      ];
    };
  };
}
