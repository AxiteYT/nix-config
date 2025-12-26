{ config, lib, ... }:
{
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    profiles.default.extensions = with pkgs.vscode-extensions; [
      openai.chatgpt
      jbockle.jbockle-format-files
      fireblast.hyprlang-vscode
      jnoortheen.nix-ide
      esbenp.prettier-vscode
      donjayamanne.githistory
      chrmarti.regex
      aaron-bond.better-comments
      streetsidesoftware.code-spell-checker
      kamikillerto.vscode-colorize
      yzhang.markdown-all-in-one
    ];
  };
}
