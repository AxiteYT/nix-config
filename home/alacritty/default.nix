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
        opacity = 1.0;
        blur = true;
        dynamic_padding = true;
      };
      terminal.shell = {
        program = "${pkgs.zsh}/bin/zsh";
      };
    };
  };

  programs.zsh = {
    enable = true;
    initContent = lib.mkBefore ''
      fsh_dir="$HOME/.zsh/fsh"
      [ -d "$fsh_dir" ] || mkdir -p "$fsh_dir"
      export FAST_WORK_DIR="$fsh_dir"
      export PATH="$PATH:$HOME/tools"
      export PATH="$PATH:$HOME/.npm-global/bin"
      [ -d "$HOME/.protostar/dist/protostar" ] && export PATH="$PATH:$HOME/.protostar/dist/protostar"
    '';
    plugins = [
      {
        name = "zsh-autosuggestions";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-autosuggestions";
          rev = "v0.7.0";
          sha256 = "sha256-KLUYpUu4DHRumQZ3w59m9aTW6TBKMCXl2UcKi4uMd7w=";
        };
      }
      {
        name = "fast-syntax-highlighting";
        src = pkgs.fetchFromGitHub {
          owner = "zdharma";
          repo = "fast-syntax-highlighting";
          rev = "v1.66";
          sha256 = "sha256-uoLrXfq31GvfHO6GTrg7Hus8da2B4SCM1Frc+mRFbFc=";
        };
      }
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "powerlevel10k-config";
        src = lib.cleanSource ./zsh;
        file = if pkgs.stdenv.isDarwin then "darwin.zsh" else "p10k.zsh";
      }
    ];
  };
}
