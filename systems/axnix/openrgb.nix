{ pkgs, lib, ... }:
let
  openrgb = lib.getExe pkgs.openrgb;
  motherboard = "X870 AORUS STEALTH ICE";
  ram = "Corsair Vengeance RGB DDR5";
  gpu = "Sapphire Radeon RX 7900 XTX Nitro+";

  # Generate the complete detector list from the pinned binary in the build
  # sandbox, then enable only this machine's internal lighting controllers.
  # This also excludes new keyboard/mouse detectors after package updates.
  settings = pkgs.runCommand "axnix-openrgb.json" { nativeBuildInputs = [ pkgs.jq ]; } ''
    export XDG_CONFIG_HOME="$TMPDIR"
    mkdir -p "$TMPDIR/OpenRGB"
    ${openrgb} --config "$TMPDIR/OpenRGB" --noautoconnect --list-devices
    jq '
      .Detectors.detectors |= with_entries(.value = (
        .key == "Corsair DRAM" or
        .key == "Gigabyte RGB Fusion 2 USB" or
        .key == "${gpu}"
      )) |
      {Detectors, Server: {default_host: "127.0.0.1", default_port: 6742}}
    ' "$TMPDIR/OpenRGB/OpenRGB.json" > "$out"
    jq -e '[.Detectors.detectors[] | select(. == true)] | length == 3' "$out"
  '';

  # The running controller exposes 256 addresses per ARGB header. Use that
  # range for uniform hardware effects, including fans behind a passive hub;
  # this capacity is not the number of physical fan LEDs.
  # Reconnect after resizing: the SDK refreshes controller objects, so cached
  # device references from the resizing command must not be used for colours.
  configureZones =
    lib.concatMapStringsSep "\n"
      (
        zone:
        toString (
          apply (
            lib.escapeShellArgs [
              "--device"
              motherboard
              "--zone"
              zone
              "--size"
              256
              "--color"
              "FFFFFF"
            ]
          )
        )
      )
      [
        0
        1
        2
      ];
  colours =
    colour:
    lib.escapeShellArgs [
      "--device"
      ram
      "--mode"
      "Direct"
      "--color"
      colour
      "--device"
      motherboard
      "--mode"
      "Static"
      "--color"
      colour
      "--device"
      gpu
      "--mode"
      "Off"
    ];
  # Automatic local SDK connection waits for the device list; explicit
  # --client can race device enumeration in OpenRGB 1.0. --nodetect prevents
  # the client from probing hardware if the server is unavailable.
  client = "${openrgb} --config /run/OpenRGB --nodetect";
  apply =
    args:
    pkgs.writeShellScript "openrgb-apply" ''
      set -eu
      output=$(${client} ${args})
      printf '%s\n' "$output"
      # OpenRGB 1.0 can print CLI errors while returning status zero.
      case "$output" in *Error:*) exit 1 ;; esac
    '';
in
{
  system.build.openrgb-settings = settings;

  services.hardware.openrgb = {
    enable = true;
    package = pkgs.openrgb;
    motherboard = "amd";
  };

  # Repair the old root-owned desktop configuration without removing profiles.
  systemd.tmpfiles.rules = [ "Z /home/axite/.config/OpenRGB - axite users -" ];

  systemd.services.openrgb = {
    wants = [ "systemd-udev-settle.service" ];
    after = [ "systemd-udev-settle.service" ];
    environment.XDG_CONFIG_HOME = "/run";
    preStart = ''
      ${pkgs.systemd}/bin/udevadm settle --timeout=10
      install -m644 ${settings} /run/OpenRGB/OpenRGB.json
    '';
    serviceConfig = {
      # Keep the server configuration separate from historical GUI profiles.
      RuntimeDirectory = "OpenRGB";
      WorkingDirectory = lib.mkForce "/run/OpenRGB";
      ExecStart = lib.mkForce "${openrgb} --config /run/OpenRGB --noautoconnect --server --server-host 127.0.0.1 --server-port 6742";
      # Wait for detection and the SDK socket, then apply the declarative state.
      ExecStartPost = pkgs.writeShellScript "openrgb-lights-on" ''
        set -eu
        for attempt in $(seq 1 30); do
          if devices=$(timeout 2 ${client} --list-devices) &&
            [ "$(printf '%s\n' "$devices" | grep -Fc '${ram}')" -ge 2 ] &&
            printf '%s\n' "$devices" | grep -Fq '${motherboard}' &&
            printf '%s\n' "$devices" | grep -Fq '${gpu}'; then
            ${configureZones}
            exec ${apply (colours "FFFFFF")}
          fi
          sleep 1
        done
        echo "OpenRGB did not detect both RAM sticks, the motherboard, and the GPU" >&2
        exit 1
      '';
      # ExecStop runs before the SDK server and its hardware access disappear.
      ExecStop = apply (colours "000000");
      TimeoutStartSec = 90;
      TimeoutStopSec = 20;
    };
  };
}
