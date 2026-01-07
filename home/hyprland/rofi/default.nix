{ pkgs, config, ... }:
let
  colors = config.lib.stylix.colors;
  hex = c: "#${c}";
  hexa = a: c: "#${c}${a}";
  font = config.stylix.fonts.sansSerif.name;
in
{
  home.packages = with pkgs; [
    rofi-wayland
  ];

  home.file = {
    ".config/rofi/config.rasi" = {
      text = ''
        configuration {
          modi: "drun,run,window";
          show-icons: true;
          drun-display-format: "{name}";
          font: "${font} 13";
        }
        @theme "stylix"
      '';
    };
    ".config/rofi/stylix.rasi" = {
      text = ''
        * {
          bg: ${hexa "cc" colors.base00};
          bg-alt: ${hexa "99" colors.base01};
          fg: ${hex colors.base06};
          fg-muted: ${hex colors.base04};
          accent: ${hex colors.base0D};
          border-color: ${hexa "66" colors.base03};
          text-color: @fg;
          font: "${font} 13";
        }

        window {
          location: center;
          anchor: center;
          width: 40%;
          border: 1px;
          border-radius: 12px;
          background-color: @bg;
          border-color: @border-color;
        }

        mainbox {
          padding: 12px;
        }

        inputbar {
          padding: 8px 10px;
          margin: 0 0 8px 0;
          background-color: @bg-alt;
          text-color: @fg;
          border-radius: 10px;
        }

        prompt {
          text-color: @fg-muted;
        }

        listview {
          lines: 8;
          spacing: 6px;
          fixed-height: true;
          dynamic: true;
        }

        element {
          padding: 8px 10px;
          border-radius: 10px;
        }

        element selected {
          background-color: @accent;
          text-color: ${hex colors.base07};
        }

        element-text {
          text-color: @fg;
        }

        element-icon {
          size: 18px;
          margin: 0 8px 0 0;
        }
      '';
    };
  };
}
