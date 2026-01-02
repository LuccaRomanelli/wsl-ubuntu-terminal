#!/bin/bash

set -e

# Portable way to get script directory (works in both bash and zsh)
if [ -n "$BASH_SOURCE" ]; then
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
else
    SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
fi
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

# Install tmux
"$ROOT_DIR/apt/install-package.sh" tmux

# Verify installation
if ! command -v tmux &>/dev/null; then
    echo "Error: tmux installation failed."
    exit 1
fi

TPM_DIR="$HOME/.tmux/plugins/tpm"

# Check if TPM is already installed
if [ -d "$TPM_DIR" ]; then
    echo "TPM is already installed in $TPM_DIR"
else
    echo "Installing Tmux Plugin Manager (TPM)..."
    git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
fi

echo "Tmux and TPM installed successfully!"
