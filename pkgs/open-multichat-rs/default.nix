{
  lib,
  rustPlatform,
  fetchFromGitHub,
  src ? fetchFromGitHub {
    owner = "AxiteYT";
    repo = "open-multichat-rs";
    rev = "5c40ad441c666838f1b3b57185a187c32b1ad988";
    hash = "sha256-ykD5us3J1LD2OprxXNDaG7i9rSIx57xidWkXFjpXs4k=";
  },
}:

rustPlatform.buildRustPackage rec {
  pname = "open-multichat-rs";
  version = "1.0.0";

  inherit src;

  cargoHash = "sha256-LIu4ChlitJ2vYK7S/m4ZqI+jWCSPdHDpw1e3+nMXV2M=";

  doCheck = false;

  postInstall = ''
    install -Dm644 README.md $out/share/doc/open-multichat-rs/README.md
    install -Dm644 LICENSE $out/share/doc/open-multichat-rs/LICENSE
    install -Dm644 config.example.toml $out/share/doc/open-multichat-rs/config.example.toml
  '';

  meta = with lib; {
    description = "Multi-streaming chat overlay for Twitch and YouTube with an OBS-friendly web UI";
    homepage = "https://github.com/AxiteYT/open-multichat-rs";
    license = licenses.gpl3Plus;
    mainProgram = "open-multichat-rs";
    platforms = platforms.unix;
    maintainers = with maintainers; [ ];
  };
}
