{ pkgs, inputs, ... }:
{
  services.plex = {
    enable = true;
    openFirewall = true;

    extraPlugins = [
      (builtins.path {
        name = "YouTube-Agent.bundle";
        path = pkgs.fetchFromGitHub {
          owner = "ZeroQI";
          repo = "YouTube-Agent.bundle";
          rev = "19aeeee561de4997741d7ddd9c6e449195b3ae76";
          sha256 = "sha256-joJPzHNZN6EpDUFMq6FuLSGdQ+MtW20t2s+GPaNzIX0=";
        };
      })
      (builtins.path {
        name = "Youtube-DL-Agent.bundle";
        path = pkgs.fetchFromGitHub {
          owner = "JordyAlkema";
          repo = "Youtube-DL-Agent.bundle";
          rev = "8f6b96180f4cae62978cb364b9e76e7892a4a508";
          sha256 = "sha256-Nvm3s3mN/zCHchot/VwE+UFkIsnv7/8B1+e5WFl2u3I=";
        };
      })
    ];
    extraScanners = [
      (pkgs.fetchFromGitHub {
        owner = "ZeroQI";
        repo = "Absolute-Series-Scanner";
        rev = "048e8001a525ba1c04afda2aa2005feb74709eb8";
        sha256 = "sha256-+j4BiGjB3vAmMYjALI+4SNyj1zlriKE0qaCNQOlmpuY=";
      })
    ];
  };
}
