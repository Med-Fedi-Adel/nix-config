#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SETTINGS="$ROOT/settings.nix"
EXAMPLE="$ROOT/settings.example.nix"

bold() { printf '\033[1m%s\033[0m\n' "$*"; }

show_welcome() {
  local banner="$ROOT/assets/obito-banner.txt"
  echo
  if [[ -f "$banner" ]]; then
    cat "$banner"
  else
    echo "  [banner missing: $banner]"
  fi
  echo
  echo "  minimal os config — trust me bro"
  echo
  echo "Press Enter to keep the value shown in brackets."
  echo
}
prompt() {
  local var="$1" label="$2" default="$3" value
  read -r -p "$(printf '%s [%s]: ' "$label" "$default")" value
  printf -v "$var" '%s' "${value:-$default}"
}

load_default() {
  local key="$1" fallback="$2"
  key="${key#.}"
  if [[ -f "$SETTINGS" ]]; then
    nix eval --impure --expr "(import \"$SETTINGS\").${key}" --raw 2>/dev/null || echo "$fallback"
  else
    echo "$fallback"
  fi
}

show_welcome

DEFAULT_USER="$(load_default ".username" "${USER:-yourusername}")"
DEFAULT_HOST="$(load_default ".hostname" "nixos")"
DEFAULT_GIT_NAME="$(load_default ".gitName" "$DEFAULT_USER")"
DEFAULT_GIT_EMAIL="$(load_default ".gitEmail" "you@example.com")"
DEFAULT_TZ="$(load_default ".timeZone" "Europe/Paris")"
DEFAULT_LOCALE="$(load_default ".locale" "en_US.UTF-8")"
DEFAULT_KB="$(load_default ".keyboardLayout" "us")"
DEFAULT_STATE="$(load_default ".stateVersion" "26.05")"

prompt USERNAME "Linux username" "$DEFAULT_USER"
prompt HOSTNAME "Machine hostname" "$DEFAULT_HOST"
prompt GIT_NAME "Git display name" "$DEFAULT_GIT_NAME"
prompt GIT_EMAIL "Git email" "$DEFAULT_GIT_EMAIL"
prompt TIMEZONE "Timezone" "$DEFAULT_TZ"
prompt LOCALE "Locale" "$DEFAULT_LOCALE"
prompt KEYBOARD "Keyboard layout" "$DEFAULT_KB"
prompt STATE_VERSION "NixOS stateVersion" "$DEFAULT_STATE"

escape_nix() {
  printf '%s' "$1" | sed "s/'/''/g"
}

cat > "$SETTINGS" <<EOF
{
  username = "$(escape_nix "$USERNAME")";
  hostname = "$(escape_nix "$HOSTNAME")";

  gitName = "$(escape_nix "$GIT_NAME")";
  gitEmail = "$(escape_nix "$GIT_EMAIL")";

  timeZone = "$(escape_nix "$TIMEZONE")";
  locale = "$(escape_nix "$LOCALE")";
  keyboardLayout = "$(escape_nix "$KEYBOARD")";

  stateVersion = "$(escape_nix "$STATE_VERSION")";
}
EOF

bold "Wrote $SETTINGS"

HOST_DIR="$ROOT/hosts/$HOSTNAME"
mkdir -p "$HOST_DIR"

if [[ ! -f "$HOST_DIR/hardware-configuration.nix" ]]; then
  if command -v nixos-generate-config >/dev/null 2>&1; then
    bold "Generating hardware config for $HOSTNAME..."
    nixos-generate-config --show-hardware-config > "$HOST_DIR/hardware-configuration.nix"
    echo "Wrote $HOST_DIR/hardware-configuration.nix"
  else
    cat > "$HOST_DIR/hardware-configuration.nix" <<'HWEOF'
# Replace this file on real hardware:
#   sudo nixos-generate-config --show-hardware-config > hosts/HOSTNAME/hardware-configuration.nix
{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.loader.systemd-boot.enable = lib.mkDefault true;
  boot.loader.efi.canTouchEfiVariables = lib.mkDefault true;

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot";
    fsType = "vfat";
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
HWEOF
    echo "Wrote placeholder $HOST_DIR/hardware-configuration.nix"
    echo "Edit disk UUIDs before rebuilding on real hardware."
  fi
else
  echo "Keeping existing $HOST_DIR/hardware-configuration.nix"
fi

echo
bold "Next steps:"
echo "  cd $ROOT"
echo "  ./rebuild.sh"
echo
echo "Or manually (note: sudo strips env vars — use env or ./rebuild.sh):"
echo "  sudo env DOTFILES_SETTINGS=\"$SETTINGS\" nixos-rebuild switch --flake .#$HOSTNAME --impure"
echo
echo "Optional (Rust LSP):"
echo "  rustup default stable && rustup component add rust-analyzer"
