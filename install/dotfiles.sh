#!/bin/bash

set -e

# Portable way to get script directory (works in both bash and zsh)
if [ -n "$BASH_SOURCE" ]; then
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
else
    SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
fi
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
GIT_SYNC_SCRIPT="$ROOT_DIR/lib/git_sync_repo.sh"
REPO_URL="git@github.com:LuccaRomanelli/dotfiles.git"
REPO_NAME="dotfiles"

# Install stow if not already installed
"$ROOT_DIR/apt/install-package.sh" stow

cd ~

# Sync the repository
"$GIT_SYNC_SCRIPT" "$REPO_URL" "$REPO_NAME"

# Check if the sync was successful
if [ $? -eq 0 ]; then
    cd "$REPO_NAME"

    # Backup existing dotfiles that would conflict with stow
    echo "Checking for existing configurations..."
    BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
    NEEDS_BACKUP=false

    # List of files that might conflict
    POTENTIAL_CONFLICTS=(
        "$HOME/.zshrc"
        "$HOME/.tmux.conf"
        "$HOME/.config/starship.toml"
        "$HOME/.gitconfig"
    )

    for file in "${POTENTIAL_CONFLICTS[@]}"; do
        if [ -e "$file" ] && [ ! -L "$file" ]; then
            if [ "$NEEDS_BACKUP" = false ]; then
                echo "Creating backup directory: $BACKUP_DIR"
                mkdir -p "$BACKUP_DIR"
                NEEDS_BACKUP=true
            fi
            echo "Backing up: $file"
            mv "$file" "$BACKUP_DIR/"
        fi
    done

    if [ "$NEEDS_BACKUP" = true ]; then
        echo "Backup completed. Old files saved in: $BACKUP_DIR"
    fi

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
