# nixos-dotfiles

Declarative NixOS + Home Manager configuration.

## Layout

```
hosts/nixos-btw/          # per-machine config + hardware
modules/system/           # shared system modules (desktop, dev, common)
modules/home/             # shared home modules (shell, dev-tools, dotfiles)
home/z4un/                # user-specific home config
config/                   # application dotfiles (nvim, rofi, alacritty)
```

## Fresh install

```bash
# 1. Clone anywhere (path is resolved via flake, not hardcoded)
git clone <repo-url> ~/nixos-dotfiles
cd ~/nixos-dotfiles

# 2. On new hardware, regenerate disk config
sudo nixos-generate-config --show-hardware-config > hosts/nixos-btw/hardware-configuration.nix

# 3. Rebuild
sudo nixos-rebuild switch --flake .#nixos-btw

# 4. Post-install (one-time)
passwd
rustup default stable
rustup component add rust-analyzer
```

## Day-to-day

```bash
cd ~/nixos-dotfiles
sudo nixos-rebuild switch --flake .#nixos-btw
```

Neovim plugins are installed on first launch via `config/nvim/lua/manage.lua`.
