{ config, pkgs, ... }:

{
  xdg.desktopEntries = {

    # OBS
    "com.obsproject.Studio" = {
      name = "OBS Studio";
      genericName = "Streaming/Recording Software";
      comment = "Free and Open Source Streaming/Recording Software";

      exec = "obs --allow-running-insecure-content --startreplaybuffer";

      icon = "com.obsproject.Studio";
      terminal = false;
      type = "Application";

      categories = [
        "AudioVideo"
        "Recorder"
      ];
      startupNotify = true;
      startupWMClass = "obs";
    };
    "brave-browser" = {
      name = "Brave Web Browser";
      genericName = "Web Browser";
      comment = "Access the Internet";

      exec = "${pkgs.brave}/bin/brave %U";

      icon = "brave-browser";
      terminal = false;
      type = "Application";
      startupNotify = true;

      categories = [
        "Network"
        "WebBrowser"
      ];

      actions = {
        "new-window" = {
          name = "New Window";
          exec = "${pkgs.brave}/bin/brave";
        };

        "new-private-window" = {
          name = "New Incognito Window";
          exec = "${pkgs.brave}/bin/brave --incognito";
        };
      };
    };
  };
}
