{ config, ... }:

let
  mediaRoot = "/media/Baitai";
in
{
  virtualisation.oci-containers.containers.kapowarr = {
    image = "mrcas/kapowarr:latest";
    ports = [ "5656:5656" ];
    environment = {
      PUID = "0";
      PGID = "0";
      TZ =
        if config.time.timeZone == null then
          "Etc/UTC"
        else
          config.time.timeZone;
    };
    volumes = [
      "/var/lib/kapowarr/db:/app/db"
      "${mediaRoot}/Downloads:/app/temp_downloads"
      "${mediaRoot}/Books:/comics"
    ];
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/kapowarr 0750 root root -"
    "d /var/lib/kapowarr/db 0750 root root -"
  ];

  systemd.services.podman-kapowarr = {
    after = [ "media-Baitai.mount" ];
    requires = [ "media-Baitai.mount" ];
  };

  networking.firewall.allowedTCPPorts = [ 5656 ];
}
