#!/bin/bash

# Batch updater for APT packages

# Portable way to get script directory (works in both bash and zsh)
if [ -n "$BASH_SOURCE" ]; then
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
else
    SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
fi
LIST_FILE="$SCRIPT_DIR/packages.list"

if [ ! -f "$LIST_FILE" ]; then
    echo "Error: Package list file not found: $LIST_FILE"
    exit 1
fi

echo "Updating APT packages..."
echo

# First, update package lists
sudo apt update

# Collect all package names
PACKAGES=""
while IFS= read -r line || [ -n "$line" ]; do
    # Skip empty lines and comments
    [[ -z "$line" || "$line" =~ ^# ]] && continue

    # Parse package_name (ignore binary_name for update)
    read -r package_name _binary_name <<< "$line"
    PACKAGES="$PACKAGES $package_name"
done < "$LIST_FILE"

# Upgrade all packages at once
if [ -n "$PACKAGES" ]; then
    echo "Upgrading packages:$PACKAGES"
    sudo apt upgrade -y $PACKAGES
fi

echo
echo "APT package updates complete!"
