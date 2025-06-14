{
  pkgs ? import <nixpkgs> { },
}:

let
  system = stdenv.system or stdenv.hostPlatform.system;
  # https://www.reddit.com/r/NixOS/comments/1c1lysh/need_help_building_javafx_projects_on_nixos/kz4ehal/
  openjdk = (pkgs.jdk23.override { enableJavaFX = true; });
  fetchurl = pkgs.fetchurl;
  stdenv = pkgs.stdenv;
  lib = pkgs.lib;
  makeWrapper = pkgs.makeWrapper;
  # Libs:
  ## https://index.ros.org/d/libxxf86vm/
  glib = pkgs.glib;
  libXxf86vm = pkgs.xorg.libXxf86vm;
  mesa = pkgs.mesa;
  gtk3 = pkgs.gtk3;
  openjfx = (pkgs.openjfx.override { withWebKit = true; });
  xwininfo = pkgs.xorg.xwininfo;
  xprop = pkgs.xorg.xprop;
in
stdenv.mkDerivation rec {
  pname = "runemate";
  version = "4.13.3.0";

  # Prevent Nix from unpacking the jar file.
  dontUnpack = true;

  src = fetchurl {
    url = "https://assets.runemate.com/client/RuneMate_${
      lib.replaceStrings [ "." ] [ "_" ] version
    }_linux_amd64.jar";
    sha256 = "sha256-ElRfA3AjI6LxrL5QUgnBPclJ7FphSVOIxADRiVfES4s=";
  };

  buildInputs = [
    openjdk
    makeWrapper
    glib
    libXxf86vm
    mesa
    gtk3
    openjfx
    xwininfo
    xprop
  ];
  sourceRoot = ".";

  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/runemate-client.jar

    # Create a wrapper using makeWrapper that invokes the jar with OpenJDK 17
    makeWrapper ${openjdk}/bin/java $out/bin/runemate-client \
      --add-flags "\
        --module-path ${openjfx}/lib --add-modules=javafx.controls,javafx.fxml,javafx.web \
        -Dprism.order=sw \
        --add-opens=javafx.graphics/com.sun.javafx.util=ALL-UNNAMED \
        --add-opens=javafx.graphics/com.sun.javafx.tk=ALL-UNNAMED \
        --add-opens=javafx.graphics/com.sun.javafx.css=ALL-UNNAMED \
        -jar $out/bin/runemate-client.jar" \
      --set LD_LIBRARY_PATH "${libXxf86vm}/lib:${glib}/lib:${mesa}/lib:${gtk3}/lib:${openjfx}/lib:$LD_LIBRARY_PATH" \
      --set PATH "${xwininfo}/bin:${xprop}/bin:$PATH"
  '';

  meta = with lib; {
    description = "Runemate Jar File";
    homepage = "https://www.runemate.com/";
    platforms = platforms.linux;
  };
}
