{ config, ... }:

let
  mediaRoot = "/media/Baitai";
in
{
  virtualisation.oci-containers.containers.chaptarr = {
    image = "chaptarr/chaptarr:latest";
    extraOptions = [ "--network=host" ];
    environment = {
      PUID = "0";
      PGID = "0";
      TZ = if config.time.timeZone == null then "Etc/UTC" else config.time.timeZone;
    };
    volumes = [
      "/var/lib/chaptarr:/config"
      "${mediaRoot}/Downloads:${mediaRoot}/Downloads"
      "${mediaRoot}/Books:/ebooks"
    ];
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/chaptarr 0750 root root -"
  ];

  systemd.services.podman-chaptarr = {
    after = [ "media-Baitai.mount" ];
    requires = [ "media-Baitai.mount" ];
  };

  networking.firewall.allowedTCPPorts = [ 8789 ];
}
