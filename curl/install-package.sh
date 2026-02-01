#!/bin/bash

# Install a single package via curl installer
# Usage: ./curl/install-package.sh <name> <check_command> <install_url>

set -e

PACKAGE_NAME="${1:-}"
CHECK_CMD="${2:-}"
INSTALL_URL="${3:-}"

if [ -z "$PACKAGE_NAME" ] || [ -z "$CHECK_CMD" ] || [ -z "$INSTALL_URL" ]; then
    echo "Error: Missing required arguments"
    echo "Usage: $0 <name> <check_command> <install_url>"
    exit 1
fi

if command -v "$CHECK_CMD" &>/dev/null; then
    echo "$PACKAGE_NAME is already installed"
    exit 0
fi

echo "Installing $PACKAGE_NAME..."

# Special handling for starship (requires -y flag)
if [ "$PACKAGE_NAME" = "starship" ]; then
    curl -fsSL "$INSTALL_URL" | sh -s -- -y
else
    curl -fsSL "$INSTALL_URL" | bash
fi

# Verify installation
if command -v "$CHECK_CMD" &>/dev/null; then
    echo "$PACKAGE_NAME installed successfully!"
elif [ -x "$HOME/.local/bin/$CHECK_CMD" ]; then
    echo "$PACKAGE_NAME installed successfully to ~/.local/bin"
else
    echo "Warning: $PACKAGE_NAME installation may have failed (command not found)"
fi
