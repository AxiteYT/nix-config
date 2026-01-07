{ pkgs, ... }:

{
  imports = [ ./alacritty ];
  programs.zsh = {

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "thefuck"
      ];
    };
  };
}
