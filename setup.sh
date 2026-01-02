#!/bin/bash

# Ubuntu Terminal Setup - Continuous Installation Script

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=== Ubuntu Terminal Setup ==="
echo ""

# Step 1: Install Zsh + Oh-My-Zsh + plugins (runs in bash)
echo "[1/7] Installing Zsh + Oh-My-Zsh + plugins..."
bash "$SCRIPT_DIR/install/zsh.sh"
echo ""

# Check if zsh was installed successfully
if ! command -v zsh &>/dev/null; then
    echo "Error: Zsh installation failed. Exiting."
    exit 1
fi

# Steps 2-6: Run remaining installations in zsh
echo "[2/7] Installing core packages..."
zsh "$SCRIPT_DIR/apt/install-packages.sh"
echo ""

echo "[3/7] Installing Starship prompt..."
zsh "$SCRIPT_DIR/install/starship.sh"
echo ""

echo "[4/7] Installing Nerd Font..."
zsh "$SCRIPT_DIR/install/nerd-font.sh"
echo ""

echo "[5/7] Installing Tmux + TPM..."
zsh "$SCRIPT_DIR/install/tmux.sh"
echo ""

echo "[6/7] Installing dotfiles..."
zsh "$SCRIPT_DIR/install/dotfiles.sh"
echo ""

# Step 7: Set zsh as default shell
echo "[7/7] Setting Zsh as default shell..."
bash "$SCRIPT_DIR/lib/set-shell.sh"
echo ""

# All done
echo "=== Installation Complete! ==="
echo ""
echo "Next steps:"
echo "  1. Restart your terminal to apply font changes"
echo "  2. Logout and login (or reboot) to apply shell change"
echo ""
echo "After that, your terminal will use Zsh with all configurations and the Nerd Font!"
echo ""
