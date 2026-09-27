{ pkgs }:
pkgs.writeShellApplication {
  name = "qbittorrent-pre-start";
  runtimeInputs = with pkgs; [
    coreutils
    perl
    procps
  ];
  text = ''
    source_config=$1
    password_file=$2
    config_dir=$3
    service_user=$4

    # Keep this assignment separate: a failed read must stop startup.
    password=$(cat -- "$password_file")
    if [[ -z "$password" || "$password" == *$'\n'* || "$password" == *$'\r'* ]]; then
      echo "qBittorrent password must be a nonempty single line" >&2
      exit 1
    fi
    if [[ ! -s "$source_config" ]]; then
      echo "qBittorrent configuration is missing or empty" >&2
      exit 1
    fi

    install -d -m 755 -- "$config_dir"
    # mktemp creates a private file on the same filesystem as the destination.
    temporary_config=$(mktemp "$config_dir/.qBittorrent.conf.XXXXXX")
    trap 'rm -f -- "$temporary_config"' EXIT

    QBT_PASSWORD_PBKDF2="$password" perl -0pe '
      my $count = s/\@BestaQB\@/$ENV{QBT_PASSWORD_PBKDF2}/g;
      die "Expected exactly one qBittorrent password placeholder\n" unless $count == 1;
    ' "$source_config" > "$temporary_config"

    # Do not mistake a pgrep error for proof that the process is stopped.
    if pgrep -u "$service_user" -x qbittorrent-nox >/dev/null; then
      echo "qBittorrent is already running; refusing to replace its configuration" >&2
      exit 1
    else
      status=$?
      if [[ "$status" -ne 1 ]]; then
        exit "$status"
      fi
    fi

    rm -f -- "$config_dir/lockfile" "$config_dir/ipc-socket"
    mv -fT -- "$temporary_config" "$config_dir/qBittorrent.conf"
  '';
}
