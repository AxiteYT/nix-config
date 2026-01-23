{ config, pkgs, ... }:
let
  colors = config.lib.stylix.colors;
  hex = c: "#${c}";
  font = config.stylix.fonts.sansSerif.name;
in
{
  programs.satty = {
    enable = true;
    settings = {
      general = {
        fullscreen = true;
        "early-exit" = true;
        "corner-roundness" = 10;
        "initial-tool" = "arrow";
        "copy-command" = "wl-copy";
        "annotation-size-factor" = 2;
        "output-filename" = "${config.home.homeDirectory}/Pictures/satty-%Y%m%d-%H%M%S.png";
        "save-after-copy" = true;
        "default-hide-toolbars" = false;
        "no-window-decoration" = true;
        "primary-highlighter" = "block";
        "brush-smooth-history-size" = 5;
      };

      font = {
        family = font;
        style = "Regular";
      };

      "color-palette" = {
        palette = [
          "${hex colors.base08}"
          "${hex colors.base09}"
          "${hex colors.base0A}"
          "${hex colors.base0B}"
          "${hex colors.base0D}"
          "${hex colors.base0E}"
          "${hex colors.base0C}"
          "${hex colors.base06}"
        ];
        custom = [
          "${hex colors.base00}"
          "${hex colors.base01}"
          "${hex colors.base02}"
          "${hex colors.base03}"
          "${hex colors.base04}"
          "${hex colors.base05}"
          "${hex colors.base07}"
        ];
      };
    };
  };

  home.packages = [
    pkgs.wl-clipboard
  ];
}
