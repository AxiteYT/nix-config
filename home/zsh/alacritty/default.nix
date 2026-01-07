{ pkgs, lib, ... }:
{
  home.sessionVariables = {
    EDITOR = "nano";
    TERMINAL = "alacritty";
  };

  programs.alacritty = {
    enable = true;
    settings = {
      font = {
        normal = {
          family = "FiraCode Nerd Font";
          style = "Regular";
        };
        bold = {
          family = "FiraCode Nerd Font";
          style = "Bold";
        };
        italic = {
          family = "FiraCode Nerd Font";
          style = "Italic";
        };
      };
      window = {
        opacity = lib.mkForce 0.2;
        blur = true;
        dynamic_padding = true;
      };
      terminal.shell = {
        program = "${pkgs.zsh}/bin/zsh";
      };
    };
  };
}
