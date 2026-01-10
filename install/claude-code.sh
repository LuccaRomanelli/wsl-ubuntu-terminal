#!/bin/bash

set -e

# Check if claude is already installed
if command -v claude &>/dev/null; then
    echo "Claude Code is already installed"
    echo "Current version: $(claude --version)"
    exit 0
fi

echo "Installing Claude Code..."

# Check if Node.js is installed and version 18+
install_node=false
if command -v node &>/dev/null; then
    NODE_VERSION=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
    if [ "$NODE_VERSION" -lt 18 ]; then
        echo "Node.js version $NODE_VERSION found, but Claude Code requires Node.js 18+"
        install_node=true
    else
        echo "Node.js $(node -v) found"
    fi
else
    echo "Node.js not found"
    install_node=true
fi

# Install Node.js 22 LTS if needed
if [ "$install_node" = true ]; then
    echo "Installing Node.js 22 LTS..."

    # Install via NodeSource
    curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
    sudo apt-get install -y nodejs

    echo "Node.js $(node -v) installed"
fi

# Install Claude Code globally
echo "Installing Claude Code via npm..."
sudo npm install -g @anthropic-ai/claude-code

# Verify installation
if command -v claude &>/dev/null; then
    echo "Claude Code installed successfully!"
    echo "Version: $(claude --version)"
    echo ""
    echo "Run 'claude' to start using Claude Code"
else
    echo "Claude Code installation failed."
    exit 1
fi
