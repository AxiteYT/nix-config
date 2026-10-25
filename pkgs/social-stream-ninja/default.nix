{
  lib,
  appimageTools,
  fetchurl,
}:
let
  pname = "social-stream-ninja";
  version = "0.4.40";
  src = fetchurl {
    url = "https://github.com/steveseguin/social_stream/releases/download/v${version}/socialstreamninja_linux_v${version}_x86_64.AppImage";
    hash = "sha256-QhGrUFi/lIdUaD2/sbs4jEZapizlHdgJsUD1eGg93t0=";
  };
  extracted = appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    install -Dm444 ${extracted}/*.desktop $out/share/applications/social-stream-ninja.desktop
    substituteInPlace $out/share/applications/social-stream-ninja.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=social-stream-ninja'
    install -Dm444 ${extracted}/*.png $out/share/icons/hicolor/512x512/apps/socialstreamninja.png
  '';

  meta = {
    description = "Combined livestream chat, overlays, and audience interaction tools";
    homepage = "https://github.com/steveseguin/social_stream";
    license = lib.licenses.gpl3Only;
    platforms = [ "x86_64-linux" ];
    mainProgram = pname;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
