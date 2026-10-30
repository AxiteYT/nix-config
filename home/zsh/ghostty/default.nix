{ pkgs, lib, ... }:
{
  home.sessionVariables = {
    EDITOR = "nano";
    TERMINAL = "ghostty";
  };

  programs.ghostty = {
    enable = true;
    settings = {
      font-family = lib.mkForce "FiraCode Nerd Font";
      font-style = "Regular";
      font-style-bold = "Bold";
      font-style-italic = "Italic";
      background-opacity = lib.mkForce 0.2;
      # Hyprland supplies background blur for transparent windows.
      window-padding-balance = true;
      command = "${pkgs.zsh}/bin/zsh";
    };
  };
}
