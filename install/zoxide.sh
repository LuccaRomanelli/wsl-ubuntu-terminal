#!/bin/bash

set -e

# Check if zoxide is already installed
if command -v zoxide &>/dev/null; then
    echo "zoxide is already installed"
    echo "Current version: $(zoxide --version)"
    exit 0
fi

echo "Installing zoxide from GitHub releases..."

# Detect architecture
ARCH=$(uname -m)
case "$ARCH" in
    x86_64)
        ZOXIDE_ARCH="x86_64"
        ;;
    aarch64|arm64)
        ZOXIDE_ARCH="aarch64"
        ;;
    *)
        echo "Error: Unsupported architecture: $ARCH"
        exit 1
        ;;
esac

# Get latest release version from GitHub API
LATEST_VERSION=$(curl -sS https://api.github.com/repos/ajeetdsouza/zoxide/releases/latest | grep '"tag_name"' | sed -E 's/.*"v([^"]+)".*/\1/')

if [ -z "$LATEST_VERSION" ]; then
    echo "Error: Could not determine latest zoxide version"
    exit 1
fi

echo "Latest version: $LATEST_VERSION"

# Download URL
DOWNLOAD_URL="https://github.com/ajeetdsouza/zoxide/releases/download/v${LATEST_VERSION}/zoxide-${LATEST_VERSION}-${ZOXIDE_ARCH}-unknown-linux-musl.tar.gz"

# Create temp directory
TMP_DIR=$(mktemp -d)
trap "rm -rf $TMP_DIR" EXIT

# Download and extract
echo "Downloading zoxide..."
curl -sL "$DOWNLOAD_URL" -o "$TMP_DIR/zoxide.tar.gz"
tar -xzf "$TMP_DIR/zoxide.tar.gz" -C "$TMP_DIR"

# Install to ~/.local/bin
mkdir -p "$HOME/.local/bin"
mv "$TMP_DIR/zoxide" "$HOME/.local/bin/zoxide"
chmod +x "$HOME/.local/bin/zoxide"

# Verify installation
if "$HOME/.local/bin/zoxide" --version &>/dev/null; then
    echo "zoxide installed successfully!"
    echo "Version: $("$HOME/.local/bin/zoxide" --version)"
else
    echo "Error: zoxide installation failed"
    exit 1
fi

# Check if ~/.local/bin is in PATH
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    echo ""
    echo "Note: ~/.local/bin is not in your PATH"
    echo "Add this to your shell config: export PATH=\"\$HOME/.local/bin:\$PATH\""
fi
