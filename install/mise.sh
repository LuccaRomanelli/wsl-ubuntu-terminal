#!/bin/bash

set -e

# Check if mise is already installed
if command -v mise &>/dev/null; then
    echo "mise is already installed"
    echo "Current version: $(mise --version)"
    exit 0
fi

echo "Installing mise using official installer..."

# Install using official script
curl -sS https://mise.run | sh

# Verify installation
if command -v mise &>/dev/null || [ -x "$HOME/.local/bin/mise" ]; then
    echo "mise installed successfully!"
    if command -v mise &>/dev/null; then
        echo "Version: $(mise --version)"
    else
        echo "Version: $("$HOME/.local/bin/mise" --version)"
    fi
else
    echo "Error: mise installation failed"
    exit 1
fi

# Check if ~/.local/bin is in PATH
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    echo ""
    echo "Note: ~/.local/bin is not in your PATH"
    echo "Add this to your shell config: export PATH=\"\$HOME/.local/bin:\$PATH\""
fi
