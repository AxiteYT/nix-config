{ ... }:
{
  programs.satty.settings = {
    general = {
      fullscreen = true;
      corner-roundness = 12;
      initial-tool = "brush";
      output-filename = "~/Pictures/Screenshots/%dd-%mm-%yy_%H:%M:%S.png";
    };
    color-palette = {
      palette = [
        "#00ffff"
        "#a52a2a"
        "#dc143c"
        "#ff1493"
        "#ffd700"
        "#008000"
      ];
    };
  };
}
