#!/usr/bin/env bash
#
# Fresh-Mac bootstrap.
#
# On a new machine the repo isn't cloned yet, so first get GitHub access:
#   gh auth login
#   clone two config repos dotfiles + nix
set -euo pipefail

CONFIG_DIR="$HOME/nix-config"
HOST="y-mac"

# 1. Nix
if ! command -v nix >/dev/null 2>&1; then
  echo ">> installing Nix"
  curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix \
    | sh -s -- install --no-confirm
  . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
fi

# 2. Homebrew
if ! command -v brew >/dev/null 2>&1; then
  echo ">> installing Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# 3. First activation
echo ">> activating nix-darwin (#$HOST)"
sudo nix run nix-darwin/master#darwin-rebuild \
  --extra-experimental-features "nix-command flakes" \
  -- switch --flake "$CONFIG_DIR#$HOST"

cat <<EOF

Done. Remaining manual steps:
  - grant Ghostty Accessibility (System Settings > Privacy > Accessibility)
  - sign into apps (VS Code Settings Sync)
EOF
