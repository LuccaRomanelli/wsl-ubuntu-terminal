#!/bin/bash

# Install a single NPM package globally
# Usage: ./npm/install-package.sh <package_name> <check_command>

set -e

PACKAGE_NAME="${1:-}"
CHECK_CMD="${2:-}"

if [ -z "$PACKAGE_NAME" ] || [ -z "$CHECK_CMD" ]; then
    echo "Error: Missing required arguments"
    echo "Usage: $0 <package_name> <check_command>"
    exit 1
fi

# Check if Node.js is available
if ! command -v node &>/dev/null; then
    echo "Error: Node.js is not installed. Please install Node.js first."
    exit 1
fi

# Check if npm is available
if ! command -v npm &>/dev/null; then
    echo "Error: npm is not installed. Please install npm first."
    exit 1
fi

if command -v "$CHECK_CMD" &>/dev/null; then
    echo "$PACKAGE_NAME is already installed"
    exit 0
fi

echo "Installing $PACKAGE_NAME..."
sudo npm install -g "$PACKAGE_NAME"

# Verify installation
if command -v "$CHECK_CMD" &>/dev/null; then
    echo "$PACKAGE_NAME installed successfully!"
else
    echo "Warning: $PACKAGE_NAME installation may have failed (command '$CHECK_CMD' not found)"
fi
