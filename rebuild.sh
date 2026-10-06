#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SETTINGS="$ROOT/settings.nix"

if [[ ! -f "$SETTINGS" ]]; then
  echo "error: $SETTINGS not found — run ./setup.sh first" >&2
  exit 1
fi

HOSTNAME="$(nix eval --impure --expr "(import \"$SETTINGS\").hostname" --raw)"

echo "Rebuilding .#$HOSTNAME (settings: $SETTINGS)"
exec sudo env DOTFILES_SETTINGS="$SETTINGS" \
  nixos-rebuild switch --flake "$ROOT#$HOSTNAME" --impure
