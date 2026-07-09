#!/usr/bin/env bash
#
# Fresh-Mac bootstrap.
#
# Prerequisites (do these manually first, the repo can't be cloned without them):
#   1. install Homebrew: https://brew.sh
#   2. brew install gh && gh auth login
#   3. clone config repos: dotfiles + nix-config
# Homebrew must exist before running this, the nix-darwin homebrew module
# manages casks/formulae but does not install brew itself.
set -euo pipefail

# the directory this script lives in, so the flake resolves wherever the repo is cloned
CONFIG_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOST="y-mac"

# 1. Nix (Determinate macOS-native .pkg, robust APFS volume handling)
if ! command -v nix >/dev/null 2>&1; then
  echo ">> installing Nix"
  curl -fsSL -o /tmp/determinate-nix.pkg \
    "https://install.determinate.systems/determinate-pkg/stable/Universal"
  sudo installer -pkg /tmp/determinate-nix.pkg -target /
  . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
fi

# 2. First activation
echo ">> activating nix-darwin (#$HOST)"
sudo nix run nix-darwin/master#darwin-rebuild \
  --extra-experimental-features "nix-command flakes" \
  -- switch --flake "$CONFIG_DIR#$HOST"

cat <<EOF

Done. Remaining manual steps:
  - grant Ghostty Accessibility (System Settings > Privacy > Accessibility)
  - sign into apps (VS Code Settings Sync)
EOF
