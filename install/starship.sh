#!/bin/bash

set -e

# Check if starship is already installed
if command -v starship &>/dev/null; then
    echo "Starship is already installed"
    echo "Current version: $(starship --version)"
    exit 0
fi

echo "Installing Starship prompt..."

# Install using official installer
curl -sS https://starship.rs/install.sh | sh -s -- -y

# Verify installation
if command -v starship &>/dev/null; then
    echo "Starship installed successfully!"
    echo "Version: $(starship --version)"
else
    echo "Starship installation failed."
    exit 1
fi
