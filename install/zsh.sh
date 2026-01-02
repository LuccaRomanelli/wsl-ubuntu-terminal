#!/bin/bash

set -e

# Portable way to get script directory (works in both bash and zsh)
if [ -n "$BASH_SOURCE" ]; then
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
else
    SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
fi
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

# Install Zsh
if ! command -v zsh &>/dev/null; then
    "$ROOT_DIR/apt/install-package.sh" zsh
fi

# Verify installation
if ! command -v zsh &>/dev/null; then
    echo "Error: Zsh installation failed"
    exit 1
fi

# Install Oh-My-Zsh if not already installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh-My-Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Install zsh-autosuggestions plugin
AUTOSUGGESTIONS_DIR="${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
if [ ! -d "$AUTOSUGGESTIONS_DIR" ]; then
    echo "Installing zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions "$AUTOSUGGESTIONS_DIR"
elif [ ! -d "$AUTOSUGGESTIONS_DIR/.git" ]; then
    echo "Removing incomplete zsh-autosuggestions installation..."
    rm -rf "$AUTOSUGGESTIONS_DIR"
    echo "Installing zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions "$AUTOSUGGESTIONS_DIR"
else
    echo "zsh-autosuggestions is already installed"
fi

# Install zsh-syntax-highlighting plugin
SYNTAX_HIGHLIGHTING_DIR="${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
if [ ! -d "$SYNTAX_HIGHLIGHTING_DIR" ]; then
    echo "Installing zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$SYNTAX_HIGHLIGHTING_DIR"
elif [ ! -d "$SYNTAX_HIGHLIGHTING_DIR/.git" ]; then
    echo "Removing incomplete zsh-syntax-highlighting installation..."
    rm -rf "$SYNTAX_HIGHLIGHTING_DIR"
    echo "Installing zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$SYNTAX_HIGHLIGHTING_DIR"
else
    echo "zsh-syntax-highlighting is already installed"
fi

echo "Zsh setup complete!"
