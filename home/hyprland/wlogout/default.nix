{ pkgs, config, ... }:
let
  colors = config.lib.stylix.colors;
  hex = c: "#${c}";
  font = config.stylix.fonts.sansSerif.name;
  wlogoutPkg = config.programs.wlogout.package or pkgs.wlogout;
  iconDir = ./icons;
  iconPath = name: "icons/${name}.png";
in
{
  programs.wlogout = {
    enable = true;
    layout = [
      {
        label = "lock";
        action = "loginctl lock-session";
        text = "Lock";
        keybind = "l";
      }
      {
        label = "logout";
        action = "hyprctl dispatch exit";
        text = "Logout";
        keybind = "e";
      }
      {
        label = "reboot";
        action = "systemctl reboot";
        text = "Reboot";
        keybind = "r";
      }
      {
        label = "shutdown";
        action = "systemctl poweroff";
        text = "Shutdown";
        keybind = "p";
      }
    ];
    style = ''
      * {
        font-family: "${font}", sans-serif;
        font-size: 14px;
        color: ${hex colors.base06};
      }

      window {
        background-color: ${hex colors.base00};
        opacity: 0.92;
      }

      button {
        background-color: ${hex colors.base02};
        border: 2px solid ${hex colors.base02};
        border-radius: 18px;
        margin: 12px;
        background-repeat: no-repeat;
        background-position: center;
        background-size: 42%;
        transition: all 0.18s ease;
        color: inherit;
        box-shadow: 0 12px 30px -10px ${hex colors.base00};
      }

      button:focus,
      button:hover {
        background-color: ${hex colors.base0D};
        border-color: ${hex colors.base0D};
        box-shadow: 0 15px 35px -12px ${hex colors.base0D};
        color: ${hex colors.base07};
        transform: translateY(-2px);
      }

      button:active {
        background-color: ${hex colors.base0D};
        transform: translateY(0);
      }

      button label {
        margin-top: 10px;
        font-size: 16px;
        font-weight: 600;
        text-shadow: none;
      }

      /* Icons are deployed to ~/.config/wlogout/icons */
      #lock { background-image: url("${iconPath "lock"}"); }
      #logout { background-image: url("${iconPath "logout"}"); }
      #reboot { background-image: url("${iconPath "reboot"}"); }
      #shutdown { background-image: url("${iconPath "shutdown"}"); }
    '';
  };

  # Ensure icons exist under ~/.config/wlogout/icons for the CSS fallback.
  xdg.configFile."wlogout/icons" = {
    source = iconDir;
    recursive = true;
  };
}
