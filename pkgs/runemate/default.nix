{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  jdk21,
  openjfx,
  glib,
  mesa,
  gtk3,
  xorg,
}:

let
  openjdk = jdk21.override { enableJavaFX = true; };
  openjfxWithWebKit = openjfx.override { withWebKit = true; };
  version = "4.17.5.1";
  versionUnderscore = lib.replaceStrings [ "." ] [ "_" ] version;
in
stdenv.mkDerivation {
  pname = "runemate";
  inherit version;

  dontUnpack = true;

  src = fetchurl {
    url = "https://assets.runemate.com/client/RuneMate_${versionUnderscore}_linux_amd64.jar";
    sha256 = "sha256-PwoIz0lqs8D28f5AmPzZGOigLacxtayLFpdlpgDJC4Y=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/runemate-client.jar

    makeWrapper ${openjdk}/bin/java $out/bin/runemate-client \
      --add-flags "\
        --module-path ${openjfxWithWebKit}/lib --add-modules=javafx.controls,javafx.fxml,javafx.web \
        -Dprism.order=sw \
        --add-opens=javafx.graphics/com.sun.javafx.util=ALL-UNNAMED \
        --add-opens=javafx.graphics/com.sun.javafx.tk=ALL-UNNAMED \
        --add-opens=javafx.graphics/com.sun.javafx.css=ALL-UNNAMED \
        -jar $out/bin/runemate-client.jar" \
      --set LD_LIBRARY_PATH "${xorg.libXxf86vm}/lib:${glib}/lib:${mesa}/lib:${gtk3}/lib:${openjfxWithWebKit}/lib:$LD_LIBRARY_PATH" \
      --set PATH "${xorg.xwininfo}/bin:${xorg.xprop}/bin:$PATH"
  '';

  meta = with lib; {
    description = "RuneMate standalone client";
    homepage = "https://www.runemate.com/";
    license = licenses.unfree;
    platforms = platforms.linux;
    mainProgram = "runemate-client";
  };
}
