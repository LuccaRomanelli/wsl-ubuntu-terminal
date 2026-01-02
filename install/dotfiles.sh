#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
GIT_SYNC_SCRIPT="$ROOT_DIR/lib/git_sync_repo.sh"
REPO_URL="git@github.com:LuccaRomanelli/dotfiles.git"
REPO_NAME="dotfiles"

is_stow_installed() {
    dpkg -l | grep -q "^ii  stow "
}

if ! is_stow_installed; then
    echo "Error: Install stow first"
    exit 1
fi

cd ~

# Sync the repository
"$GIT_SYNC_SCRIPT" "$REPO_URL" "$REPO_NAME"

# Check if the sync was successful
if [ $? -eq 0 ]; then
    echo "Removing old configs..."
    rm -rf ~/.config/starship.toml

    cd "$REPO_NAME"

    # Stow configurations (Ubuntu-specific subset)
    echo "Stowing dotfiles..."
    stow zshrc
    stow tmux
    stow starship
    stow gitconfig
    stow gitconfig-gitlab

    echo "Dotfiles configured successfully!"
else
    echo "Error: Failed to sync the repository."
    exit 1
fi
