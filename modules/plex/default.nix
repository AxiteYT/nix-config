{ pkgs, inputs, ... }:
let
  hamaTvPlugin = pkgs.stdenv.mkDerivation {
    name = "Hama.bundle";
    src = pkgs.fetchFromGitHub {
      owner = "ZeroQI";
      repo = "Hama.bundle";
      rev = "16c8a40a7b004ed14e46cd457d8c393672a09c5a";
      sha256 = "08a0pfjr1ba9q41b0lcgmqrlj8i2a4d4irqxbckc5a1z6xzcr8nr";
    };
    buildInputs = [ pkgs.unzip ];
    installPhase = "mkdir -p $out; cp -R * $out/";
  };
  xbmcNfoTvImporterPlugin = pkgs.stdenv.mkDerivation {
    name = "XBMCnfoTVImporter.bundle";
    src = pkgs.fetchFromGitHub {
      owner = "gboudreau";
      repo = "XBMCnfoTVImporter.bundle";
      rev = "534e7737886135b2d0b43d8ae9ee394f1a116051";
      sha256 = "vygO3w8xTMq420sz1OtxDRXJPL/pvWV3SqHb253r2bE=";
    };
    installPhase = "mkdir -p $out; cp -R * $out/";
  };
in
{
  services.plex = {
    enable = true;
    openFirewall = true;

    extraPlugins = [
      hamaTvPlugin
      xbmcNfoTvImporterPlugin
    ];

    extraScanners = [
      (pkgs.fetchFromGitHub {
        owner = "ZeroQI";
        repo = "Absolute-Series-Scanner";
        rev = "773a39f502a1204b0b0255903cee4ed02c46fde0";
        sha256 = "4l+vpiDdC8L/EeJowUgYyB3JPNTZ1sauN8liFAcK+PY=";
      })
    ];
  };
}
