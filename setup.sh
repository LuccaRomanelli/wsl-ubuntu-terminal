#!/bin/bash

# Ubuntu Terminal Setup - Continuous Installation Script

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=== Ubuntu Terminal Setup ==="
echo ""

# Step 1: Install Zsh + Oh-My-Zsh + plugins (runs in bash)
echo "[1/9] Installing Zsh + Oh-My-Zsh + plugins..."
bash "$SCRIPT_DIR/install/zsh.sh"
echo ""

# Check if zsh was installed successfully
if ! command -v zsh &>/dev/null; then
    echo "Error: Zsh installation failed. Exiting."
    exit 1
fi

# Steps 2-7: Run remaining installations in zsh
echo "[2/9] Installing core packages..."
zsh "$SCRIPT_DIR/apt/install-packages.sh"
echo ""

echo "[3/9] Installing Neovim Kickstart..."
zsh "$SCRIPT_DIR/install/nvim.sh"
echo ""

echo "[4/9] Installing Claude Code..."
zsh "$SCRIPT_DIR/install/claude-code.sh"
echo ""

echo "[5/9] Installing Starship prompt..."
zsh "$SCRIPT_DIR/install/starship.sh"
echo ""

echo "[6/9] Installing Nerd Font..."
zsh "$SCRIPT_DIR/install/nerd-font.sh"
echo ""

echo "[7/9] Installing Tmux + TPM..."
zsh "$SCRIPT_DIR/install/tmux.sh"
echo ""

echo "[8/9] Installing dotfiles..."
zsh "$SCRIPT_DIR/install/dotfiles.sh"
echo ""

# Step 9: Set zsh as default shell
echo "[9/9] Setting Zsh as default shell..."
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
