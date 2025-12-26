{ config, lib, pkgs, ... }:
{
  stylix.targets.vscode = {
    enable = true;
    profileNames = [ "default" ];
  };

  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    profiles.default.extensions = with pkgs.vscode-extensions; [
      aaron-bond.better-comments
      donjayamanne.githistory
      esbenp.prettier-vscode
      jbockle.jbockle-format-files
      jnoortheen.nix-ide
      kamikillerto.vscode-colorize
      yzhang.markdown-all-in-one
    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "regex";
        publisher = "chrmarti";
        version = "0.6.0";
        sha256 = "Exw2CuSsJKphgSTAK72DxkO+oHv2I4LGo6BV3NvYVCs=";
      }
      {
        name = "hyprlang-vscode";
        publisher = "fireblast";
        version = "0.0.3";
        sha256 = "iMCyomgMGGUXaVqq1l7bgyvFgZa/W/eWHaqkA5RmExE=";
      }
      {
        name = "chatgpt";
        publisher = "openai";
        version = "0.5.56";
        sha256 = "FAy2Cf2XnOnctBBATloXz8y4cLNHBoXAVnlw42CQzN8=";
      }
    ];
  };
}
