#!/bin/bash

# Update a single APT package
# Usage: ./apt/update-package.sh <package_name> [binary_name]

PACKAGE_NAME=$1
BINARY_NAME=${2:-$1}

if [ -z "$PACKAGE_NAME" ]; then
    echo "Error: Package name is required"
    echo "Usage: $0 <package_name> [binary_name]"
    exit 1
fi

# Check if package is installed
if ! dpkg -l "$PACKAGE_NAME" &>/dev/null; then
    echo "$PACKAGE_NAME is not installed. Skipping update."
    exit 0
fi

echo "Updating $PACKAGE_NAME..."
sudo apt update && sudo apt install -y --only-upgrade "$PACKAGE_NAME"
echo "$PACKAGE_NAME update complete!"
