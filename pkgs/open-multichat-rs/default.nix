{
  lib,
  rustPlatform,
  pkg-config,
  clang,
  llvmPackages,
  obs-studio,
  src,
}:

rustPlatform.buildRustPackage rec {
  pname = "open-multichat-rs";
  version = "0.1.0";

  inherit src;

  cargoLock = {
    lockFile = "${src}/Cargo.lock";
  };

  nativeBuildInputs = [
    pkg-config
    clang
  ];

  buildInputs = [
    obs-studio
  ];

  LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";

  postInstall = ''
    mkdir -p $out/lib/obs-plugins

    if [ -f "$out/lib/libobs_multichat.so" ]; then
      mv "$out/lib/libobs_multichat.so" "$out/lib/obs-plugins/"
    fi
  '';

  meta = {
    description = "OBS source plugin that merges Twitch and YouTube live chat";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
}
