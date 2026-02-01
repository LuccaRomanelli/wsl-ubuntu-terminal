#!/bin/bash

# Uninstall all packages and configurations
# WARNING: This will remove all installed packages!

set -e

# Portable way to get script directory (works in both bash and zsh)
if [ -n "$BASH_SOURCE" ]; then
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
else
    SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
fi
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "=== Ubuntu Terminal Uninstall ==="
echo ""
echo "WARNING: This will remove all installed packages and configurations!"
read -p "Are you sure you want to continue? (y/N) " -n 1 -r
echo

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Uninstall cancelled."
    exit 0
fi

echo ""
echo "Removing GitHub releases packages..."
for binary in fzf yazi ya zoxide lazygit; do
    if [ -f "$HOME/.local/bin/$binary" ]; then
        echo "  Removing $binary..."
        rm -f "$HOME/.local/bin/$binary"
    fi
done

echo ""
echo "Removing curl-installed packages..."
for binary in mise starship nhost; do
    if [ -f "$HOME/.local/bin/$binary" ]; then
        echo "  Removing $binary..."
        rm -f "$HOME/.local/bin/$binary"
    fi
done
# Starship may also be in /usr/local/bin
if [ -f "/usr/local/bin/starship" ]; then
    echo "  Removing starship from /usr/local/bin..."
    sudo rm -f /usr/local/bin/starship
fi

echo ""
echo "Removing NPM packages..."
for pkg in "@anthropic-ai/claude-code" "@devcontainers/cli"; do
    if npm list -g "$pkg" &>/dev/null; then
        echo "  Removing $pkg..."
        sudo npm uninstall -g "$pkg" || true
    fi
done

echo ""
echo "Removing cloned repositories..."
for repo in obsidian dotfiles shell; do
    if [ -d "$HOME/$repo" ]; then
        echo "  Removing $HOME/$repo..."
        rm -rf "$HOME/$repo"
    fi
done

echo ""
echo "Removing Neovim config..."
if [ -d "$HOME/.config/nvim" ]; then
    echo "  Removing $HOME/.config/nvim..."
    rm -rf "$HOME/.config/nvim"
fi

echo ""
echo "=== Uninstall Complete! ==="
echo ""
echo "Note: APT packages, Zsh, Oh-My-Zsh, Tmux, and TPM were not removed."
echo "To fully clean up, you may want to:"
echo "  - Remove Oh-My-Zsh: ~/.oh-my-zsh"
echo "  - Remove Tmux Plugin Manager: ~/.tmux/plugins/tpm"
echo "  - Change default shell back to bash: chsh -s /bin/bash"
