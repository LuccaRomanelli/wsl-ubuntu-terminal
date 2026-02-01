#!/bin/bash

# Batch installer for APT packages

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

echo "Installing APT packages from $LIST_FILE..."
echo

# Add Neovim unstable PPA for latest version (only if nvim not installed)
if ! command -v nvim &>/dev/null; then
    echo "Adding Neovim unstable PPA..."
    sudo add-apt-repository ppa:neovim-ppa/unstable -y
    echo
fi

while IFS= read -r line || [ -n "$line" ]; do
    # Skip empty lines and comments
    [[ -z "$line" || "$line" =~ ^# ]] && continue

    # Parse package_name and optional binary_name
    read -r package_name binary_name <<< "$line"

    # Call centralized installer with proper arguments
    if [ -n "$binary_name" ]; then
        "$SCRIPT_DIR/install-package.sh" "$package_name" "$binary_name"
    else
        "$SCRIPT_DIR/install-package.sh" "$package_name"
    fi
done < "$LIST_FILE"

echo
echo "APT package installation complete!"
