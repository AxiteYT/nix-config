{
  services.sonarr =
    #TODO: Remove sqlite pinning once it resolved upstream: https://github.com/NixOS/nixpkgs/issues/481098
    let
      sqlite-3-50 = pkgs.sqlite.overrideAttrs (old: {
        version = "3.50.0";
        src = pkgs.fetchurl {
          url = "https://sqlite.org/2025/sqlite-autoconf-3500000.tar.gz";
          sha256 = "09w32b04wbh1d5zmriwla7a02r93nd6vf3xqycap92a3yajpdirv";
        };
      });
    in
    {
      enable = true;
      package = pkgs.unstable.sonarr.override { sqlite = sqlite-3-50; };
      group = "servarr";
      openFirewall = true;
    };
}
