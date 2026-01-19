{
  virtualisation = {
    podman.enable = true;
    oci-containers = {
      backend = "podman";
      containers = {
        kometa = {
          image = "kometateam/kometa:nightly";
          volumes = [ "/var/lib/kometa/config:/config:rw" ];
          autoRemoveOnStop = false;
          podman.user = "besta";
        };
      };
    };
  };
}
