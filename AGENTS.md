# AI repository guide

## Purpose and source of truth

This repository is a personal, flake-based Nix configuration for four NixOS
machines and one nix-darwin machine. `flake.nix` defines the inputs, outputs,
host composition, formatter, and installer ISO. `flake.lock` is generated pin
state; change it through Nix commands, never by hand.

There is no separate README, CI workflow, development shell, or flake `checks`
output. Treat the evaluated host configurations as the primary validation
surface.

These instructions cover the whole repository.

## Safety and change discipline

- Inspect `git status --short` and the relevant diff before editing. The
  worktree may contain user changes; preserve unrelated edits and never revert
  them as cleanup.
- Do not run `nixos-rebuild switch`, `darwin-rebuild switch`, Disko install or
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
- Disko, Home Manager, SOPS-Nix, nix-darwin, Stylix, and MCP-NixOS follow the
  primary `nixpkgs` input where configured. `nixos-hardware` and the Hytale
  launcher are additional inputs.
- `specialArgs = { inherit self inputs; };` makes the flake source and all
  inputs available to host modules. Existing modules commonly import
  repository paths as `(self + /path)` and use relative imports for sibling
  files. Because `self` is a Git-flake snapshot, a newly created imported file
  is invisible to normal `.#...` evaluation until Git tracks it.
- `flake-utils.lib.eachDefaultSystem` publishes the treefmt formatter for its
  default systems. On `x86_64-linux` it also publishes `packages.axnix` and
  `packages.bootable-iso`.
- The installer ISO uses the stable NixOS module set but deliberately selects
  `linuxPackages_latest` from the primary package set and removes ZFS from its
  supported filesystems.
- `systems/common/default.nix` enables unfree packages and defines the shared
  overlay. The overlay disables OpenLDAP checks for native and i686 package
  sets and exposes the local OBS Aitum package both at top level and under
  `obs-studio-plugins`. It affects NixOS hosts only, not Darwin, the ISO, or the
  separately imported stable package set.
- The common package policy permits the exact insecure package
  `nexusmods-app-unfree-0.21.1`. Treat a version change as a security-policy
  change, not just a package bump.
- `pkgs/obs-aitum-stream-suite/default.nix` is the only local derivation. When
  updating it, keep the version/tag/hash aligned and validate a consuming host.
- `patches/ffmpeg-tableprint-vlc-av_malloc.patch` is currently not referenced
  by any Nix expression and is not a valid standalone patch in its present
  form. Do not assume that merely editing it changes a build.

## Host composition

| Flake output                    | Platform         | Role and important composition                                                                                                                                                                                 |
| ------------------------------- | ---------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `nixosConfigurations.axnix`     | `x86_64-linux`   | Main AMD/Hyprland workstation. Common + `systems/axnix` + Stylix + Disko on `/dev/nvme0n1` + Home Manager `home/axite.nix`. Imports AMD, Keychron, OpenRazer, Flatpak, Steam, and the local Apollo filesystem. |
| `nixosConfigurations.axtop`     | `x86_64-linux`   | Microsoft Surface Pro 3/Hyprland laptop. Common + `systems/axtop` + nixos-hardware Surface module + Stylix + Disko + Home Manager `home/axtop.nix`. Uses the Disko `/dev/sda` default.                         |
| `nixosConfigurations.besta`     | `x86_64-linux`   | QEMU Servarr host at `10.1.10.85`. Common + server profile + `systems/besta` + Disko. Imports the Baitai NFS mount and the aggregate Servarr/qBittorrent stack.                                                |
| `nixosConfigurations.baitai`    | `x86_64-linux`   | QEMU media host at `10.1.10.77`. Common + server profile + `systems/baitai` + Disko. Runs Jellyfin and Kavita with Intel graphics and the Baitai NFS mount.                                                    |
| `darwinConfigurations.axdarwin` | `aarch64-darwin` | Apple Silicon host for user `axite`, with nix-darwin and Home Manager via `home/axite-darwin.nix`. See current caveats below before relying on this output.                                                    |

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
- `systems/<host>/`: host imports, packages, hardware/session choices,
  networking, and state version. Desktop Home Manager profiles are wired here.
- `systems/common/mounts/`: deployment-specific local/NFS mounts. Several
  media services require `/media/Baitai`, so mount changes affect their systemd
  ordering and runtime access. The share source is `10.1.10.10`, which is not
  the `baitai` host address (`10.1.10.77`).
- `hardware/`: reusable device or platform fragments. Disko is separate from
  ordinary driver fragments because it defines storage layout and bootloader
  behavior.
- `modules/`: reusable NixOS service/feature modules, except
  `modules/hyprland/swaync`, which is imported from the `axnix` Home Manager
  profile and uses Home Manager's `services.swaync` option.
- `home/`: Home Manager profiles and reusable user modules. Put managed
  dotfiles and user-scoped programs here, not in `environment.systemPackages`.
- `home/hyprland/config.nix`: shared generated Hyprland `conf.d` content plus
  per-host monitor layouts. `mkConfigFiles` marks generated files with
  `force = true`; deployment can replace existing files under
  `~/.config/hypr/conf.d`.
- `home/zsh/p10k.nix`: an opaque, base64-backed generated Powerlevel10k
  artifact. Avoid reformatting its payload or making casual inline edits;
  regenerate it deliberately when prompt behavior changes.
- `pkgs/`: local package expressions consumed through the common overlay.
- `patches/`: source patches; verify that a patch is actually referenced before
  treating it as active.
- `secrets/`: encrypted SOPS data only. Secret consumers declare
  `sops.secrets.<name>` in the relevant module and read the generated runtime
  path from `config.sops.secrets.<name>.path`.

Some empty local directories may exist from abandoned or future work. Nix and
Git do not track empty directories; do not infer active features from their
names.

Most feature modules are unconditional and declare no custom enable option.
Importing one enables its configuration; removing its import disables it.

## Desktop and Home Manager structure

- `modules/hyprland/default.nix` provides system-level Hyprland, greetd, fonts,
  Nautilus integration, a Waybar audio/Bluetooth helper, and supporting
  packages. Desktop hosts import it explicitly; portals come from the separate
  `modules/flatpak` import.
- Stylix is enabled per desktop host using One Dark and supplies palette/font
  values consumed by Home Manager modules such as Waybar, Wofi, Wleave, Satty,
  VSCodium, and Hyprland.
- `home/axite.nix` is the workstation profile;
  `home/axtop.nix` is the laptop profile. Their import lists are the clearest
  place to enable or disable a user feature for one desktop.
- Shared Hyprland behavior lives in `home/hyprland/config.nix`; monitor geometry
  lives in its `monitors.axnix` and `monitors.axtop` values. Keep per-host
  wrappers small.
- NixOS-integrated Home Manager uses `backupFileExtension = "hm-bak"` and
  `overwriteBackup = true`, so activation may replace the previous backup.
- Desktop packages are currently split between system package lists and Home
  Manager modules. Follow the established location for the feature being
  changed; avoid installing the same package in both scopes without a reason.
- NixOS `specialArgs` do not automatically become Home Manager arguments. Wire
  `home-manager.extraSpecialArgs` if a Linux Home Manager module needs `inputs`
  or `self`; the Darwin configuration already does this explicitly.
- Shared Hyprland config invokes external commands. In particular,
  `brightnessctl` and `playerctl` are not currently provisioned directly, and
  the shared OBS/StreamController autostarts also apply to `axtop` even though
  those packages are only listed on `axnix`. Check both config and package
  availability when changing commands.

## Server service structure

- `modules/servarr/default.nix` is an aggregate module for qBittorrent, Bazarr,
  Flaresolverr, Kapowarr, Prowlarr, Radarr, Recyclarr, Seerr, and Sonarr. It also
  creates the shared `servarr` group.
- `modules/qbittorrent/default.nix` injects SOPS values at service start and
  manages the companion `qui` service. Preserve secret ownership/modes,
  localhost binding assumptions, startup ordering, and state-directory
  hardening when changing it. Its pre-start customization assumes the first
  upstream `restartTriggers` item is the generated configuration and replaces
  the upstream `ExecStartPre`, so re-check it after nixpkgs module changes. It
  writes to `/media/Baitai` without the explicit mount dependency used by the
  other media services.
- Jellyfin and Kavita run on `baitai` and require `/media/Baitai`. Jellyfin uses
  Intel Quick Sync and an nginx virtual host; Kavita reads its token key from
  SOPS.
- Kapowarr uses a mutable `mrcas/kapowarr:latest` OCI image, host networking,
  and root PUID/PGID. Evaluation does not prove that the image or external NFS
  content will be available at runtime.
- Service modules intentionally open several firewall ports. Review both the
  service's `openFirewall` option and explicit firewall lists when changing
  exposure.

## Where to make common changes

- Add a package to every NixOS host: `systems/common/default.nix`.
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

On the native `x86_64-linux` system, the normal non-building flake check is
also useful and currently covers the formatter, Linux packages, and all four
NixOS configurations:

```sh
nix flake check --no-build
```

Evaluate every changed NixOS host without building or activating it:

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
darwin-rebuild switch --flake .#axdarwin
```

For a change to a shared module, evaluate every host that imports it. A
successful evaluation checks module types and package resolution, but does not
test boot, hardware, remote mounts, container pulls, or service credentials.

## Current validation caveats

As reviewed on 2026-09-03:

- `axnix`, `axtop`, `besta`, and `baitai` all evaluate to system derivations.
- The x86_64 installer ISO evaluates to a derivation.
- `axdarwin` does not evaluate because `home/axite-darwin.nix` imports the
  nonexistent tracked path `home/alacritty`; the available Alacritty module is
  under `home/zsh/alacritty` and should not be rewired without deciding whether
  its Linux-oriented settings belong on Darwin.
- Repository-wide `nix flake show --all-systems` and
  `nix flake check --all-systems` fail while `eachDefaultSystem` requests
  `x86_64-darwin`, which the pinned unstable nixpkgs no longer supports. Use
  targeted host evaluations until the supported-system list is corrected.
- The `axtop` evaluation emits a Home Manager warning because its Hyprland
  `configType` is implicit; `axnix` explicitly keeps `"hyprlang"`.

Do not fix these caveats as part of an unrelated task. If a task touches one of
them, report whether the baseline failure changed.
