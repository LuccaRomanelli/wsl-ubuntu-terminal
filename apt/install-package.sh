#!/bin/bash

# Centralized APT package installer
# Usage: ./apt/install-package.sh <package_name> [binary_name]

PACKAGE_NAME=$1
BINARY_NAME=${2:-$1}

if [ -z "$PACKAGE_NAME" ]; then
    echo "Error: Package name is required"
    echo "Usage: $0 <package_name> [binary_name]"
    exit 1
fi

if command -v "$BINARY_NAME" &>/dev/null; then
    echo "$BINARY_NAME is already installed"
    exit 0
fi

# Fallback: check if package is installed via dpkg (for packages without binaries)
if dpkg -s "$PACKAGE_NAME" &>/dev/null 2>&1; then
    echo "$PACKAGE_NAME is already installed (no binary)"
    exit 0
fi

echo "Installing $PACKAGE_NAME..."
sudo apt update && sudo apt install -y "$PACKAGE_NAME"
exit $?
