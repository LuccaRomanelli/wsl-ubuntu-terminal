#!/bin/bash

# Ubuntu Terminal Setup - Continuous Installation Script

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=== Ubuntu Terminal Setup ==="
echo ""

# Step 1: Install Zsh + Oh-My-Zsh + plugins (runs in bash)
echo "[1/16] Installing Zsh + Oh-My-Zsh + plugins..."
bash "$SCRIPT_DIR/install/zsh.sh"
echo ""

# Check if zsh was installed successfully
if ! command -v zsh &>/dev/null; then
    echo "Error: Zsh installation failed. Exiting."
    exit 1
fi

# Steps 2-16: Run remaining installations in zsh
echo "[2/16] Installing core packages..."
zsh "$SCRIPT_DIR/apt/install-packages.sh"
echo ""

echo "[3/16] Installing fzf..."
zsh "$SCRIPT_DIR/install/fzf.sh"
echo ""

echo "[4/16] Installing Neovim Kickstart..."
zsh "$SCRIPT_DIR/install/nvim.sh"
echo ""

echo "[5/16] Installing Claude Code..."
zsh "$SCRIPT_DIR/install/claude-code.sh"
echo ""

echo "[6/16] Installing Starship prompt..."
zsh "$SCRIPT_DIR/install/starship.sh"
echo ""

echo "[7/16] Installing Nerd Font..."
zsh "$SCRIPT_DIR/install/nerd-font.sh"
echo ""

echo "[8/16] Installing Tmux + TPM..."
zsh "$SCRIPT_DIR/install/tmux.sh"
echo ""

echo "[9/16] Installing yazi..."
zsh "$SCRIPT_DIR/install/yazi.sh"
echo ""

echo "[10/16] Installing zoxide..."
zsh "$SCRIPT_DIR/install/zoxide.sh"
echo ""

echo "[11/16] Installing lazygit..."
zsh "$SCRIPT_DIR/install/lazygit.sh"
echo ""

echo "[12/16] Installing mise..."
zsh "$SCRIPT_DIR/install/mise.sh"
echo ""

echo "[13/16] Installing dotfiles..."
zsh "$SCRIPT_DIR/install/dotfiles.sh"
echo ""

echo "[14/16] Cloning shell scripts..."
zsh "$SCRIPT_DIR/install/shell-scripts.sh"
echo ""

echo "[15/16] Cloning Obsidian vault..."
zsh "$SCRIPT_DIR/install/obsidian-vault.sh"
echo ""

# Step 16: Set zsh as default shell
echo "[16/16] Setting Zsh as default shell..."
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
