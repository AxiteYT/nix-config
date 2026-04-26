{ config, ... }:
{
  sops.secrets.BestaRecyclarrSonarrApiKey = { };
  sops.secrets.BestaRecyclarrRadarrApiKey = { };

  services.recyclarr = {
    enable = true;
    schedule = "daily";

    configuration = {
      sonarr.tv = {
        base_url = "http://127.0.0.1:8989";
        api_key._secret = config.sops.secrets.BestaRecyclarrSonarrApiKey.path;
        delete_old_custom_formats = true;
        quality_definition = {
          type = "series";
        };
        quality_profiles = [
          {
            trash_id = "72dae194fc92bf828f32cde7744e51a1"; # WEB-1080p
            reset_unmatched_scores.enabled = true;
          }
          {
            trash_id = "d1498e7d189fbe6c7110ceaabb7473e6"; # WEB-2160p
            reset_unmatched_scores.enabled = true;
          }
        ];
      };

      radarr.movies = {
        base_url = "http://127.0.0.1:7878";
        api_key._secret = config.sops.secrets.BestaRecyclarrRadarrApiKey.path;
        delete_old_custom_formats = true;
        quality_definition = {
          type = "movie";
        };
        quality_profiles = [
          {
            trash_id = "d1d67249d3890e49bc12e275d989a7e9"; # HD Bluray + WEB
            reset_unmatched_scores.enabled = true;
          }
          {
            trash_id = "64fb5f9858489bdac2af690e27c8f42f"; # UHD Bluray + WEB
            reset_unmatched_scores.enabled = true;
          }
        ];
      };
    };
  };
}
