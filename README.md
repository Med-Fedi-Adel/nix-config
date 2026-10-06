# nixos-dotfiles

Declarative NixOS + Home Manager configuration.

## Quick start (new user / new machine)

```bash
git clone <repo-url> ~/nixos-dotfiles
cd ~/nixos-dotfiles
chmod +x setup.sh rebuild.sh
./setup.sh
./rebuild.sh
passwd
rustup default stable && rustup component add rust-analyzer
```

`setup.sh` writes gitignored `settings.nix`. Use `./rebuild.sh` to apply — it passes settings through sudo correctly.

## Layout

```
settings.example.nix    # template (committed)
settings.nix            # your values (generated, gitignored)
setup.sh                # interactive setup
hosts/
  default.nix           # shared host config
  HOSTNAME/
    hardware-configuration.nix
modules/system/         # desktop, dev, locale
modules/home/           # shell, dev-tools, dotfiles
home/default.nix        # home-manager entry
config/                 # nvim, rofi, alacritty dotfiles
```

## Day-to-day

```bash
cd ~/nixos-dotfiles
sudo nixos-rebuild switch --flake .#$(nix eval --impure --expr 'import ./settings.nix' --apply 's: s.hostname' 2>/dev/null | tr -d '"')
```

Or use your hostname directly, e.g. `.#nixos-btw`.

Neovim plugins install on first launch via `config/nvim/lua/manage.lua`.
