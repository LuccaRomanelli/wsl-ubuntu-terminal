#!/bin/bash

# Update a single package via curl installer (reinstall)
# Usage: ./curl/update-package.sh <name> <check_command> <install_url>

set -e

PACKAGE_NAME="${1:-}"
CHECK_CMD="${2:-}"
INSTALL_URL="${3:-}"

if [ -z "$PACKAGE_NAME" ] || [ -z "$CHECK_CMD" ] || [ -z "$INSTALL_URL" ]; then
    echo "Error: Missing required arguments"
    echo "Usage: $0 <name> <check_command> <install_url>"
    exit 1
fi

if ! command -v "$CHECK_CMD" &>/dev/null && [ ! -x "$HOME/.local/bin/$CHECK_CMD" ]; then
    echo "$PACKAGE_NAME is not installed. Skipping update."
    exit 0
fi

echo "Updating $PACKAGE_NAME..."

# Special handling for starship (requires -y flag)
if [ "$PACKAGE_NAME" = "starship" ]; then
    curl -fsSL "$INSTALL_URL" | sh -s -- -y
else
    curl -fsSL "$INSTALL_URL" | bash
fi

echo "$PACKAGE_NAME update complete!"
