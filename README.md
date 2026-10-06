# nixos-dotfiles

Declarative NixOS configuration with Home Manager, Plasma 6, Neovim, and dev tooling.

## Prerequisites

- NixOS 26.05 (or compatible) with flakes enabled
- Git
- Sudo access
- An internet connection for the first rebuild (downloads packages from cache.nixos.org)

If flakes are not enabled yet, add to `/etc/nix/nix.conf`:

```
experimental-features = nix-command flakes
```

This repo enables the same setting in `modules/system/common.nix` once applied.

---

## Installation

### 1. Clone the repository

```bash
git clone <repo-url> ~/nixos-dotfiles
cd ~/nixos-dotfiles
chmod +x setup.sh rebuild.sh
```

The repo can live anywhere, but `~/nixos-dotfiles` is the conventional path.

### 2. Configure your machine

Run the interactive setup script. It asks for:

- Linux username and hostname
- Git name and email
- Timezone, locale, and keyboard layout
- NixOS `stateVersion`

```bash
./setup.sh
```

This writes `settings.nix` (gitignored — your personal values stay local).

On a **real NixOS machine**, setup also generates `hosts/HOSTNAME/hardware-configuration.nix` from your disks. On a non-NixOS system it writes a placeholder — replace that file before rebuilding on hardware:

```bash
sudo nixos-generate-config --show-hardware-config \
  > hosts/YOUR_HOSTNAME/hardware-configuration.nix
```

### 3. Apply the configuration

```bash
./rebuild.sh
```

`rebuild.sh` reads your hostname from `settings.nix` and passes it through `sudo` correctly (plain `sudo` drops environment variables and breaks the build).

The first rebuild downloads packages and can take a while. Later rebuilds are much faster.

### 4. Post-install (one-time)

```bash
passwd
rustup default stable
rustup component add rust-analyzer rustfmt
```

Open Neovim once so plugins are cloned automatically (`config/nvim/lua/manage.lua`).

---

## Day-to-day use

After changing any file in this repo:

```bash
cd ~/nixos-dotfiles
./rebuild.sh
```

To rebuild manually:

```bash
sudo env DOTFILES_SETTINGS="$PWD/settings.nix" \
  nixos-rebuild switch --flake .#YOUR_HOSTNAME --impure
```

Replace `YOUR_HOSTNAME` with the value from `settings.nix` (e.g. `nixos-btw`).

---

## Troubleshooting

**`flake does not provide attribute nixosConfigurations.HOSTNAME`**
Run `./setup.sh` and confirm `settings.nix` exists. Always use `./rebuild.sh` instead of bare `sudo nixos-rebuild`.

**Home Manager corrupted `config/nvim` into symlinks**
Do not set `recursive = true` in dotfiles config. Restore with `git checkout -- config/nvim` and rebuild.

**`rust-analyzer` / `cargo-fmt` path conflicts**
Rust tools come from `rustup`, not Nix. Do not add `rust-analyzer` or `rustfmt` to `dev-tools.nix`.

**Disk/boot errors on new hardware**
Regenerate `hosts/HOSTNAME/hardware-configuration.nix` with `nixos-generate-config`.
