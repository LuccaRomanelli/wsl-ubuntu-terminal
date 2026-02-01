#!/bin/bash

# Ubuntu Terminal Setup - Continuous Installation Script

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=== Ubuntu Terminal Setup ==="
echo ""

# Step 1: Install Zsh + Oh-My-Zsh + plugins (runs in bash)
echo "[1/12] Installing Zsh + Oh-My-Zsh + plugins..."
bash "$SCRIPT_DIR/install/zsh.sh"
echo ""

# Check if zsh was installed successfully
if ! command -v zsh &>/dev/null; then
    echo "Error: Zsh installation failed. Exiting."
    exit 1
fi

# Steps 2-8: Run remaining installations in zsh
echo "[2/12] Installing core packages..."
zsh "$SCRIPT_DIR/apt/install-packages.sh"
echo ""

echo "[3/12] Installing fzf..."
zsh "$SCRIPT_DIR/install/fzf.sh"
echo ""

echo "[4/12] Installing Neovim Kickstart..."
zsh "$SCRIPT_DIR/install/nvim.sh"
echo ""

echo "[5/12] Installing Claude Code..."
zsh "$SCRIPT_DIR/install/claude-code.sh"
echo ""

echo "[6/12] Installing Starship prompt..."
zsh "$SCRIPT_DIR/install/starship.sh"
echo ""

echo "[7/12] Installing Nerd Font..."
zsh "$SCRIPT_DIR/install/nerd-font.sh"
echo ""

echo "[8/12] Installing Tmux + TPM..."
zsh "$SCRIPT_DIR/install/tmux.sh"
echo ""

echo "[9/12] Installing dotfiles..."
zsh "$SCRIPT_DIR/install/dotfiles.sh"
echo ""

echo "[10/12] Cloning shell scripts..."
zsh "$SCRIPT_DIR/install/shell-scripts.sh"
echo ""

echo "[11/12] Cloning Obsidian vault..."
zsh "$SCRIPT_DIR/install/obsidian-vault.sh"
echo ""

# Step 12: Set zsh as default shell
echo "[12/12] Setting Zsh as default shell..."
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
