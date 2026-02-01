#!/bin/bash

# Batch installer for GitHub releases packages

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

echo "Installing GitHub releases packages from $LIST_FILE..."
echo

while IFS= read -r line || [ -n "$line" ]; do
    # Skip empty lines and comments
    [[ -z "$line" || "$line" =~ ^# ]] && continue

    # Parse: name repo binary_name
    read -r name repo binary_name <<< "$line"

    "$SCRIPT_DIR/install-package.sh" "$name" "$repo" "$binary_name"
done < "$LIST_FILE"

echo
echo "GitHub releases package installation complete!"
