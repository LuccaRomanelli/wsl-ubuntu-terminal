#!/bin/bash

# Batch installer for NPM global packages

set -e

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

# Check for Node.js
if ! command -v node &>/dev/null; then
    echo "Node.js not found. Installing Node.js 22 LTS..."
    curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
    sudo apt-get install -y nodejs
    echo "Node.js $(node -v) installed"
fi

echo "Installing NPM packages from $LIST_FILE..."
echo

while IFS= read -r line || [ -n "$line" ]; do
    # Skip empty lines and comments
    [[ -z "$line" || "$line" =~ ^# ]] && continue

    # Parse: package_name check_command
    read -r package_name check_cmd <<< "$line"

    "$SCRIPT_DIR/install-package.sh" "$package_name" "$check_cmd"
done < "$LIST_FILE"

echo
echo "NPM package installation complete!"
