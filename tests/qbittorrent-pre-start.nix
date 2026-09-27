{ pkgs }:
let
  prepare = import ../modules/qbittorrent/pre-start.nix { inherit pkgs; };
in
pkgs.runCommand "qbittorrent-pre-start-test" { } ''
  mkdir config
  printf 'previous configuration\n' > config/qBittorrent.conf
  cp config/qBittorrent.conf previous.conf
  printf '[Preferences]\nWebUI\\Password_PBKDF2=@BestaQB@\n' > template.conf
  # Synthetic fixture only; never read real SOPS secrets in a build.
  printf '%s\n' '@ByteArray(test$hash\\with/slashes&symbols)' > password
  service_user=$(id -un)

  expect_failure() {
    if ${pkgs.lib.getExe prepare} "$1" "$2" "$PWD/config" "$service_user"; then
      echo "Unexpected success: $1 / $2" >&2
      exit 1
    fi
    cmp previous.conf config/qBittorrent.conf
    test -z "$(find config -name '.qBittorrent.conf.*' -print)"
  }

  expect_failure template.conf missing-password
  touch empty-password
  expect_failure template.conf empty-password
  printf 'first\nsecond\n' > multiline-password
  expect_failure template.conf multiline-password
  expect_failure missing-template password
  touch empty-template
  expect_failure empty-template password
  printf '[Preferences]\n' > missing-placeholder
  expect_failure missing-placeholder password
  cat template.conf template.conf > duplicate-placeholder
  expect_failure duplicate-placeholder password

  touch config/lockfile config/ipc-socket
  ${pkgs.lib.getExe prepare} template.conf password "$PWD/config" "$service_user"
  { printf '[Preferences]\nWebUI\\Password_PBKDF2='; cat password; } > expected.conf
  cmp expected.conf config/qBittorrent.conf
  test "$(stat -c %a config/qBittorrent.conf)" = 600
  test ! -e config/lockfile
  test ! -e config/ipc-socket
  test -z "$(find config -name '.qBittorrent.conf.*' -print)"
  touch "$out"
''
