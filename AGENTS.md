# AI repository guide

## Purpose and source of truth

This repository is a personal, flake-based Nix configuration for three NixOS
machines. `flake.nix` defines the inputs, outputs,
host composition, formatter, and installer ISO. `flake.lock` is generated pin
state; change it through Nix commands, never by hand.

There is no separate README or development shell. `.github/workflows/validate.yml`
runs the flake checks on pushes and pull requests, with manual dispatch also
available. Checks evaluate every host and the installer ISO, check formatting,
test qBittorrent startup and Wofi CSS, and build the local OBS plugin.

These instructions cover the whole repository.

## Safety and change discipline

- Inspect `git status --short` and the relevant diff before editing. The
  worktree may contain user changes; preserve unrelated edits and never revert
  them as cleanup.
- Do not run `nixos-rebuild switch`, Disko install or
  format operations, secret re-encryption, or broad flake updates unless the
  user explicitly asks for the corresponding state change.
- `hardware/disk-config/default.nix` describes a destructive whole-disk GPT
  layout. Its default target is `/dev/sda`; `axnix` overrides it to
  `/dev/nvme0n1`. Never infer that either target is correct for a live machine.
- Do not change any `system.stateVersion` or `home.stateVersion` merely to match
  the current release. These are compatibility contracts, not package-channel
  selectors.
- Never expose decrypted values from `secrets/secrets.yaml`. It is a tracked
  SOPS document; `.sops.yaml` controls its age recipients. Servers decrypt with
  their SSH host key, while other NixOS configurations default to the root age
  key at `/root/.config/sops/age/keys.txt`.
- `.gitignore` does not provide a blanket ignore rule for plaintext keys or
  decrypted secret files. Never create them anywhere in this repository.
- Hostnames, UUIDs, static addresses, ports, mount paths, user/group IDs, and
  hardware-specific settings are intentional deployment data. Do not
  generalize or rename them as cosmetic cleanup.
- Keep generated build links and images out of changes. `result`, `*.iso`,
  `.DS_Store`, and `.vscode/` are ignored. The existing `result` symlink is only
  a local build artifact.

## Flake and package model

- `nixpkgs` follows `nixos-unstable` and is the default package set.
- `nixpkgs-stable` follows `nixos-25.11`. Import it explicitly when a package
  must be pinned to stable; `systems/axnix/default.nix` calls that package set
  `pkgsStable` and currently uses it for LibreOffice and RPCS3.
- Disko, Home Manager, SOPS-Nix, Stylix, and MCP-NixOS follow the primary
  `nixpkgs` input where configured. The Hytale launcher is an additional input.
- `specialArgs = { inherit self inputs; };` makes the flake source and all
  inputs available to host modules. Existing modules commonly import
  repository paths as `(self + /path)` and use relative imports for sibling
  files. Because `self` is a Git-flake snapshot, a newly created imported file
  is invisible to normal `.#...` evaluation until Git tracks it.
- `flake-utils.lib.eachSystem` explicitly targets only `x86_64-linux`, the
  platform of every deployed host. It publishes the treefmt formatter, checks,
  `packages.axnix`, and `packages.bootable-iso`.
- The installer ISO uses the stable NixOS module set but deliberately selects
  `linuxPackages_latest` from the primary package set and removes ZFS from its
  supported filesystems.
- `systems/common/default.nix` enables unfree packages and defines the shared
  overlay. The overlay disables OpenLDAP checks for native and i686 package
  sets and exposes the local OBS Aitum package both at top level and under
  `obs-studio-plugins`. It affects NixOS hosts only, not the ISO or the
  separately imported stable package set.
- The common package policy permits the exact insecure package
  `nexusmods-app-unfree-0.21.1`. Treat a version change as a security-policy
  change, not just a package bump.
- `pkgs/obs-aitum-stream-suite/default.nix` is the only local application package
  under `pkgs/`. When
  updating it, keep the version/tag/hash aligned and validate a consuming host.
- `patches/ffmpeg-tableprint-vlc-av_malloc.patch` is currently not referenced
  by any Nix expression and is not a valid standalone patch in its present
  form. Do not assume that merely editing it changes a build.

## Host composition

| Flake output                 | Platform       | Role and important composition                                                                                                                                                                                                               |
| ---------------------------- | -------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `nixosConfigurations.axnix`  | `x86_64-linux` | Main AMD/Hyprland workstation. Common + desktop profile + `systems/axnix` + Stylix + Disko on `/dev/nvme0n1` + Home Manager `home/axite.nix`. Imports AMD, Keychron, OpenRazer, and Steam; the desktop profile imports Flatpak and Hyprland. |
| `nixosConfigurations.besta`  | `x86_64-linux` | QEMU Servarr host at `10.10.30.85`. Common + server profile + `systems/besta` + Disko. Imports the Baitai NFS mount and the aggregate Servarr/qBittorrent stack.                                                                             |
| `nixosConfigurations.baitai` | `x86_64-linux` | QEMU media host at `10.10.30.77`. Common + server profile + `systems/baitai` + Disko. Runs Jellyfin with Intel graphics and the Baitai NFS mount.                                                                                            |

All NixOS hosts inherit `systems/common/default.nix`. `besta` and `baitai` also
inherit `systems/server/default.nix`, which selects QEMU guest support, static
network defaults, serial console output, and SOPS decryption through the SSH
host key.

## Directory responsibilities

- `systems/common/`: policy shared by every NixOS host: package policy and
  overlay, SOPS, SSH, user `axite`, timezone/domain, firmware, garbage
  collection, baseline packages, and latest-kernel default.
- `systems/server/`: shared QEMU server behavior. Keep machine-specific
  services and addresses in the relevant host directory.
- `systems/desktop/`: shared desktop packages, Stylix palette/fonts/cursor,
  Qt environment, Home Manager backup policy, PipeWire, and Bluetooth. The
  profile imports the Flatpak and Hyprland modules. Host composition still
  supplies the Stylix and Home Manager NixOS modules in `flake.nix`.
- `systems/<host>/`: host imports, packages, hardware/session choices,
  networking, and state version. Desktop Home Manager profiles are wired here.
- `systems/common/mounts/`: deployment-specific local/NFS mounts. Several
  media services require `/media/Baitai`, so mount changes affect their systemd
  ordering and runtime access. The share source is `10.10.40.10`, which is not
  the `baitai` host address (`10.10.30.77`).
- `hardware/`: reusable device or platform fragments. Disko is separate from
  ordinary driver fragments because it defines storage layout and bootloader
  behavior.
- `modules/`: reusable NixOS service/feature modules, except
  `modules/hyprland/swaync`, which is imported from the `axnix` Home Manager
  profile and uses Home Manager's `services.swaync` option.
- `home/`: Home Manager profiles and reusable user modules. Put managed
  dotfiles and user-scoped programs here, not in `environment.systemPackages`.
- `home/hyprland/config.nix`: shared generated Hyprland Lua modules.
  `home/hyprland/axite.nix` supplies workstation monitor geometry and autostarts.
  `mkLuaFiles` combines the monitor module with shared modules for Home Manager's
  `extraLuaFiles`; Home Manager generates `hyprland.lua` and loads them from
  `~/.config/hypr`.
- `home/zsh/p10k.nix`: an opaque, base64-backed generated Powerlevel10k
  artifact. Avoid reformatting its payload or making casual inline edits;
  regenerate it deliberately when prompt behavior changes.
- `pkgs/`: local package expressions consumed through the common overlay.
- `patches/`: source patches; verify that a patch is actually referenced before
  treating it as active.
- `secrets/`: encrypted SOPS data only. Secret consumers declare
  `sops.secrets.<name>` in the relevant module and read the generated runtime
  path from `config.sops.secrets.<name>.path`.
- `tests/`: build-time regression checks. The qBittorrent check uses synthetic
  fixtures in the build sandbox; it must never read real SOPS secrets. The Wofi
  check parses the generated stylesheet with the pinned GTK 3 library.

Some empty local directories may exist from abandoned or future work. Nix and
Git do not track empty directories; do not infer active features from their
names.

Most feature modules are unconditional and declare no custom enable option.
Importing one enables its configuration; removing its import disables it.

## Desktop and Home Manager structure

- `modules/hyprland/default.nix` provides system-level Hyprland, greetd, fonts,
  Nautilus integration, a Waybar audio/Bluetooth helper, and supporting
  packages. The desktop profile imports it alongside `modules/flatpak` for
  portal and Flatpak configuration.
- Stylix is enabled by the desktop profile using One Dark and supplies palette/font
  values consumed by Home Manager modules such as Waybar, Wofi, Wleave, Satty,
  VSCodium, and Hyprland.
- `home/axite.nix` is the workstation profile. Its import list is the clearest
  place to enable or disable a user feature.
- Shared Hyprland behavior lives in `home/hyprland/config.nix`; monitor geometry
  and application autostarts live in `home/hyprland/axite.nix`.
- NixOS-integrated Home Manager uses `backupFileExtension = "hm-bak"` and
  `overwriteBackup = true`, so activation may replace the previous backup.
- Desktop packages are currently split between system package lists and Home
  Manager modules. Follow the established location for the feature being
  changed; avoid installing the same package in both scopes without a reason.
- NixOS `specialArgs` do not automatically become Home Manager arguments. Wire
  `home-manager.extraSpecialArgs` if a Linux Home Manager module needs `inputs`
  or `self`.
- Shared Hyprland config invokes external commands. In particular,
  `brightnessctl` and `playerctl` are not currently provisioned directly.
  These bindings and the existing MIME associations were intentionally left
  unchanged in the 2026-09-27 review fixes. Check both config and package
  availability when changing commands.

## Server service structure

- `modules/servarr/default.nix` is an aggregate module for qBittorrent, Bazarr,
  Chaptarr, Flaresolverr, Prowlarr, Radarr, Recyclarr, Seerr, and Sonarr. It also
  creates the shared `servarr` group.
- `modules/qbittorrent/default.nix` injects SOPS values at service start and
  manages the companion `qui` service. Preserve secret ownership/modes,
  localhost binding assumptions, startup ordering, and state-directory
  hardening when changing it. Its pre-start customization assumes the first
  upstream `restartTriggers` item is the generated configuration and replaces
  the upstream `ExecStartPre`, so re-check it after nixpkgs module changes.
  `pre-start.nix` checks its inputs, prepares a mode-0600 temporary file, and
  atomically replaces the configuration only after successful preparation.
- qBittorrent, Sonarr, Radarr, and Bazarr declare `RequiresMountsFor` on
  `/media/Baitai`; Chaptarr requires the corresponding mount unit. Preserve these
  dependencies when changing service modules or mount paths.
- SOPS restarts qBittorrent and qui when their startup credentials
  change. qui has `PartOf=qbittorrent.service` so it follows qBittorrent restarts.
  Recyclarr reads fresh credentials on each scheduled run, so it has no
  secret-rotation restart hook.
- Jellyfin runs on `baitai` and requires `/media/Baitai`. Jellyfin uses
  Intel Quick Sync and an nginx virtual host.
- Chaptarr uses a mutable `docker.io/chaptarr/chaptarr:latest` OCI image, host networking,
  and root PUID/PGID. Evaluation does not prove that the image or external NFS
  content will be available at runtime.
- Service modules intentionally open several firewall ports. Review both the
  service's `openFirewall` option and explicit firewall lists when changing
  exposure.

## Where to make common changes

- Add a package to every NixOS host: `systems/common/default.nix`.
- Add shared desktop policy or baseline packages: `systems/desktop/default.nix`.
- Add a package to one host: that host's `environment.systemPackages`.
- Add a user program or dotfile: a module under `home/`, imported by the
  intended Home Manager profile.
- Add a reusable system service/feature: a module under `modules/`, then import
  it only from the intended host or aggregate module.
- Add device support: a focused fragment under `hardware/`, imported by the
  relevant host.
- Add or change a flake input: edit `flake.nix`, update only the intended lock
  node when possible, and inspect both diffs.
- Use stable nixpkgs for an isolated package: import or reuse `pkgsStable` and
  qualify only that package; do not silently move the whole host to stable.
- Add a secret consumer: declare it with SOPS, use its runtime path, and arrange
  for the encrypted key to exist separately. Never place plaintext in a Nix
  expression because evaluated Nix strings can enter the world-readable store.

## Formatting and validation

The flake formatter is treefmt with nixfmt, Prettier, and shfmt. Even
`--fail-on-change` may rewrite files before reporting failure, so limit it to
the files in scope and inspect the resulting diff when unrelated worktree
changes are present:

```sh
nix fmt -- --fail-on-change path/to/changed-file.nix
git diff --check
```

On `x86_64-linux`, evaluate all checks without building:

```sh
nix flake check --all-systems --no-build --no-write-lock-file
```

The `checks.eval-<host>` and `checks.eval-iso` derivations explicitly force each
`drvPath`, catching failures that a bare `nixosConfigurations` check can miss.
They discard the derivation string context so building these small checks does
not build the host closures or ISO.

Run the full CI validation locally:

```sh
nix flake check --all-systems --no-write-lock-file --print-build-logs
```

This also builds the local OBS plugin, tests qBittorrent preparation and Wofi
CSS, and checks formatting in a build sandbox without rewriting the worktree.

For a targeted host evaluation without building or activating it:

```sh
nix eval --raw .#nixosConfigurations.<host>.config.system.build.toplevel.drvPath
```

Useful targeted commands are:

```sh
# Build, but do not activate, a host closure.
nix build .#nixosConfigurations.<host>.config.system.build.toplevel

# Build the local OBS plugin without replacing the ignored result symlink.
nix build .#nixosConfigurations.axnix.pkgs.obs-aitum-stream-suite --no-link

# Evaluate or build the installer ISO on x86_64 Linux.
nix eval --raw .#packages.x86_64-linux.bootable-iso.drvPath
nix build .#packages.x86_64-linux.bootable-iso

# Deployment commands; run only when explicitly requested, on the target OS.
sudo nixos-rebuild test --flake .#<host>
sudo nixos-rebuild switch --flake .#<host>
```

For a change to a shared module, evaluate every host that imports it. A
successful evaluation checks module types and package resolution, but does not
test boot, hardware, remote mounts, container pulls, or service credentials.

## Current validation status

As reviewed on 2026-09-27:

- All three hosts (`axnix`, `besta`, and `baitai`) and the installer ISO evaluate.
- Full flake checks pass on `x86_64-linux`, including the local OBS plugin,
  qBittorrent failure cases, Wofi CSS parsing, and repository formatting.
- Checks do not build full host closures or the ISO, activate configurations,
  decrypt secrets, or exercise hardware and external services.
