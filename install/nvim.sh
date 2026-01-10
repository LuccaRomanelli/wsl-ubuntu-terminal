#!/bin/bash

set -e

# Install Neovim Kickstart configuration

NVIM_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"

# Clone kickstart.nvim if not already installed
if [ ! -d "$NVIM_CONFIG_DIR" ]; then
    echo "Installing Neovim Kickstart..."
    git clone https://github.com/LuccaRomanelli/kickstart.nvim.git "$NVIM_CONFIG_DIR"
elif [ ! -d "$NVIM_CONFIG_DIR/.git" ]; then
    echo "Removing incomplete nvim config..."
    rm -rf "$NVIM_CONFIG_DIR"
    echo "Installing Neovim Kickstart..."
    git clone https://github.com/LuccaRomanelli/kickstart.nvim.git "$NVIM_CONFIG_DIR"
else
    echo "Neovim Kickstart is already installed"
fi

echo "Neovim Kickstart setup complete!"
