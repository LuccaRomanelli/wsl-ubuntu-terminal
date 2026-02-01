#!/bin/bash

# Ubuntu Terminal Update - Update all packages and repositories

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=== Ubuntu Terminal Update ==="
echo ""

echo "[1/5] Updating APT packages..."
zsh "$SCRIPT_DIR/apt/update-packages.sh"
echo ""

echo "[2/5] Updating GitHub releases packages..."
zsh "$SCRIPT_DIR/github-releases/update-packages.sh"
echo ""

echo "[3/5] Updating curl-based packages..."
zsh "$SCRIPT_DIR/curl/update-packages.sh"
echo ""

echo "[4/5] Updating NPM packages..."
zsh "$SCRIPT_DIR/npm/update-packages.sh"
echo ""

echo "[5/5] Syncing git repositories..."
zsh "$SCRIPT_DIR/git/sync-repos.sh"
echo ""

echo "=== Update Complete! ==="
