{ pkgs, config, ... }:
let
  colors = config.lib.stylix.colors;
  hex = c: "#${c}";
  hexa = a: c: "#${c}${a}";
  font = config.stylix.fonts.sansSerif.name;
  wlogoutPkg = config.programs.wlogout.package or pkgs.wlogout;
  iconDir = ./icons;
  icon = name:
    ''image(url("${config.xdg.configHome}/wlogout/icons/${name}.png"),
      url("${wlogoutPkg}/share/wlogout/icons/${name}.png"),
      url("${config.home.profileDirectory}/share/wlogout/icons/${name}.png"),
      url("/run/current-system/sw/share/wlogout/icons/${name}.png"),
      url("/usr/share/wlogout/icons/${name}.png"))'';
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
        background-color: ${hexa "cc" colors.base00};
      }

      button {
        background-color: ${hexa "33" colors.base02};
        border: 2px solid ${hexa "55" colors.base02};
        border-radius: 18px;
        margin: 12px;
        background-repeat: no-repeat;
        background-position: center 35%;
        background-size: 30%;
        transition: all 0.18s ease;
        color: inherit;
        box-shadow: 0 12px 30px -10px ${hexa "40" colors.base00};
      }

      button:focus,
      button:hover {
        background-color: ${hexa "55" colors.base0D};
        border-color: ${hex colors.base0D};
        box-shadow: 0 15px 35px -12px ${hexa "66" colors.base0D};
        color: ${hex colors.base07};
        transform: translateY(-2px);
      }

      button:active {
        background-color: ${hexa "88" colors.base0D};
        transform: translateY(0);
      }

      button label {
        margin-top: 10px;
        font-size: 16px;
        font-weight: 600;
        text-shadow: none;
      }

      #lock { background-image: ${icon "lock"}; }
      #logout { background-image: ${icon "logout"}; }
      #reboot { background-image: ${icon "reboot"}; }
      #shutdown { background-image: ${icon "shutdown"}; }
    '';
  };

  # Ensure icons exist under ~/.config/wlogout/icons for the CSS fallback.
  xdg.configFile."wlogout/icons" = {
    source = iconDir;
    recursive = true;
  };
}
