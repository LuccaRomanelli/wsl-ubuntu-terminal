#!/bin/bash

# Ubuntu Terminal Setup - Continuous Installation Script

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=== Ubuntu Terminal Setup ==="
echo ""

# Step 1: Install Zsh + Oh-My-Zsh + plugins (runs in bash)
echo "[1/6] Installing Zsh + Oh-My-Zsh + plugins..."
bash "$SCRIPT_DIR/install/zsh.sh"
echo ""

# Check if zsh was installed successfully
if ! command -v zsh &>/dev/null; then
    echo "Error: Zsh installation failed. Exiting."
    exit 1
fi

# Steps 2-5: Run remaining installations in zsh
echo "[2/6] Installing core packages..."
zsh "$SCRIPT_DIR/apt/install-packages.sh"
echo ""

echo "[3/6] Installing Starship prompt..."
zsh "$SCRIPT_DIR/install/starship.sh"
echo ""

echo "[4/6] Installing Tmux + TPM..."
zsh "$SCRIPT_DIR/install/tmux.sh"
echo ""

echo "[5/6] Installing dotfiles..."
zsh "$SCRIPT_DIR/install/dotfiles.sh"
echo ""

# Step 6: Set zsh as default shell
echo "[6/6] Setting Zsh as default shell..."
bash "$SCRIPT_DIR/lib/set-shell.sh"
echo ""

# All done
echo "=== Installation Complete! ==="
echo ""
echo "To apply the shell change, please:"
echo "  - Logout and login again, OR"
echo "  - Reboot your system"
echo ""
echo "After that, your terminal will use Zsh with all configurations."
echo ""
