{ pkgs, lib, ... }:

{
  imports = [ ./alacritty ];

  home.file.".p10k.zsh".source = ./p10k.zsh;

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

    # This runs after OMZ/theme init (good place to source p10k config)
    initExtra = ''
      [[ -r ~/.p10k.zsh ]] && source ~/.p10k.zsh
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
    ];

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
      ];
    };
  };
}
