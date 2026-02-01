#!/bin/bash

# Update a single NPM package globally
# Usage: ./npm/update-package.sh <package_name> <check_command>

set -e

PACKAGE_NAME="${1:-}"
CHECK_CMD="${2:-}"

if [ -z "$PACKAGE_NAME" ] || [ -z "$CHECK_CMD" ]; then
    echo "Error: Missing required arguments"
    echo "Usage: $0 <package_name> <check_command>"
    exit 1
fi

if ! command -v "$CHECK_CMD" &>/dev/null; then
    echo "$PACKAGE_NAME is not installed. Skipping update."
    exit 0
fi

echo "Updating $PACKAGE_NAME..."
sudo npm update -g "$PACKAGE_NAME"
echo "$PACKAGE_NAME update complete!"
