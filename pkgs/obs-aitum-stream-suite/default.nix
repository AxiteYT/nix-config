{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  curl,
  obs-studio,
  qtbase,
}:

stdenv.mkDerivation rec {
  pname = "obs-aitum-stream-suite";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "Aitum";
    repo = "obs-aitum-stream-suite";
    tag = version;
    hash = "sha256-WpsrT7z2NTQEqK+4T1hl3MAA6MkD6N3BSH1ocIjRaLs=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    curl
    obs-studio
    qtbase
  ];

  cmakeFlags = [
    "-DBUILD_OUT_OF_TREE=On"
    (lib.cmakeBool "QT_FIND_PRIVATE_MODULES" true)
    (lib.cmakeOptionType "string" "CMAKE_CXX_FLAGS" "-Wno-error=deprecated-declarations")
  ];

  dontWrapQtApps = true;

  meta = {
    description = "Aitum Stream Suite plugin for OBS Studio";
    homepage = "https://github.com/Aitum/obs-aitum-stream-suite";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ ];
    inherit (obs-studio.meta) platforms;
  };
}
