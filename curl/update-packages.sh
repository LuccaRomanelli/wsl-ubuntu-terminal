#!/bin/bash

# Batch updater for curl-based packages

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

echo "Updating curl packages from $LIST_FILE..."
echo

while IFS= read -r line || [ -n "$line" ]; do
    # Skip empty lines and comments
    [[ -z "$line" || "$line" =~ ^# ]] && continue

    # Parse: name check_command install_url
    read -r name check_cmd install_url <<< "$line"

    "$SCRIPT_DIR/update-package.sh" "$name" "$check_cmd" "$install_url"
done < "$LIST_FILE"

echo
echo "Curl package updates complete!"
