{ lib, ... }:
{
  xdg.configFile."pavucontrol.ini".text = lib.generators.toINI { } {
    window = {
      width = 500;
      height = 400;
      sinkInputType = 0;
      sourceOutputType = 0;
      sinkType = 0;
      sourceType = 1;
      showVolumeMeters = 1;
      hideUnavailableCardProfiles = 0;
    };
  };
}
