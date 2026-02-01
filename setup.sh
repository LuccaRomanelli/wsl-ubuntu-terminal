#!/bin/bash

# Ubuntu Terminal Setup - Modular Installation Script

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=== Ubuntu Terminal Setup ==="
echo ""

# Step 1: Install Zsh + Oh-My-Zsh + plugins (runs in bash)
echo "[1/8] Installing Zsh + Oh-My-Zsh + plugins..."
bash "$SCRIPT_DIR/install/zsh.sh"
echo ""

# Check if zsh was installed successfully
if ! command -v zsh &>/dev/null; then
    echo "Error: Zsh installation failed. Exiting."
    exit 1
fi

# Step 2: Install APT packages
echo "[2/8] Installing APT packages..."
zsh "$SCRIPT_DIR/apt/install-packages.sh"
echo ""

# Step 3: Install GitHub releases packages (fzf, yazi, zoxide, lazygit)
echo "[3/8] Installing GitHub releases packages..."
zsh "$SCRIPT_DIR/github-releases/install-packages.sh"
echo ""

# Step 4: Install curl-based packages (mise, starship, nhost)
echo "[4/8] Installing curl-based packages..."
zsh "$SCRIPT_DIR/curl/install-packages.sh"
echo ""

# Step 5: Install NPM packages (claude-code, devcontainer)
echo "[5/8] Installing NPM packages..."
zsh "$SCRIPT_DIR/npm/install-packages.sh"
echo ""

# Step 6: Install Nerd Font
echo "[6/8] Installing Nerd Font..."
zsh "$SCRIPT_DIR/install/nerd-font.sh"
echo ""

# Step 7: Install Tmux + TPM
echo "[7/8] Installing Tmux + TPM..."
zsh "$SCRIPT_DIR/install/tmux.sh"
echo ""

# Step 8: Clone git repositories (dotfiles, nvim, shell, obsidian)
echo "[8/8] Cloning git repositories..."
zsh "$SCRIPT_DIR/git/clone-repos.sh"
echo ""

# Set zsh as default shell
echo "Setting Zsh as default shell..."
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
