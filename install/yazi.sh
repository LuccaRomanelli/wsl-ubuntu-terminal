#!/bin/bash

set -e

# Check if yazi is already installed
if command -v yazi &>/dev/null; then
    echo "yazi is already installed"
    echo "Current version: $(yazi --version | head -n1)"
    exit 0
fi

echo "Installing yazi from GitHub releases..."

# Detect architecture
ARCH=$(uname -m)
case "$ARCH" in
    x86_64)
        YAZI_ARCH="x86_64"
        ;;
    aarch64|arm64)
        YAZI_ARCH="aarch64"
        ;;
    *)
        echo "Error: Unsupported architecture: $ARCH"
        exit 1
        ;;
esac

# Get latest release version from GitHub API
LATEST_VERSION=$(curl -sS https://api.github.com/repos/sxyazi/yazi/releases/latest | grep '"tag_name"' | sed -E 's/.*"v([^"]+)".*/\1/')

if [ -z "$LATEST_VERSION" ]; then
    echo "Error: Could not determine latest yazi version"
    exit 1
fi

echo "Latest version: $LATEST_VERSION"

# Download URL
DOWNLOAD_URL="https://github.com/sxyazi/yazi/releases/download/v${LATEST_VERSION}/yazi-${YAZI_ARCH}-unknown-linux-gnu.zip"

# Create temp directory
TMP_DIR=$(mktemp -d)
trap "rm -rf $TMP_DIR" EXIT

# Download and extract
echo "Downloading yazi..."
curl -sL "$DOWNLOAD_URL" -o "$TMP_DIR/yazi.zip"
unzip -q "$TMP_DIR/yazi.zip" -d "$TMP_DIR"

# Install to ~/.local/bin
mkdir -p "$HOME/.local/bin"
mv "$TMP_DIR/yazi-${YAZI_ARCH}-unknown-linux-gnu/yazi" "$HOME/.local/bin/yazi"
mv "$TMP_DIR/yazi-${YAZI_ARCH}-unknown-linux-gnu/ya" "$HOME/.local/bin/ya"
chmod +x "$HOME/.local/bin/yazi" "$HOME/.local/bin/ya"

# Verify installation
if "$HOME/.local/bin/yazi" --version &>/dev/null; then
    echo "yazi installed successfully!"
    echo "Version: $("$HOME/.local/bin/yazi" --version | head -n1)"
else
    echo "Error: yazi installation failed"
    exit 1
fi

# Check if ~/.local/bin is in PATH
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    echo ""
    echo "Note: ~/.local/bin is not in your PATH"
    echo "Add this to your shell config: export PATH=\"\$HOME/.local/bin:\$PATH\""
fi
