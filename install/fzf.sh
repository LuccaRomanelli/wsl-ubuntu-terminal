#!/bin/bash

set -e

# Minimum version required for --zsh flag
MIN_VERSION="0.48.0"

# Check if fzf is already installed with sufficient version
if command -v fzf &>/dev/null; then
    CURRENT_VERSION=$(fzf --version | awk '{print $1}')
    if [ "$(printf '%s\n' "$MIN_VERSION" "$CURRENT_VERSION" | sort -V | head -n1)" = "$MIN_VERSION" ]; then
        echo "fzf $CURRENT_VERSION is already installed (>= $MIN_VERSION)"
        exit 0
    else
        echo "fzf $CURRENT_VERSION found, but >= $MIN_VERSION required"
        echo "Upgrading fzf..."
    fi
fi

echo "Installing fzf from GitHub releases..."

# Detect architecture
ARCH=$(uname -m)
case "$ARCH" in
    x86_64)
        FZF_ARCH="amd64"
        ;;
    aarch64|arm64)
        FZF_ARCH="arm64"
        ;;
    *)
        echo "Error: Unsupported architecture: $ARCH"
        exit 1
        ;;
esac

# Get latest release version from GitHub API
LATEST_VERSION=$(curl -sS https://api.github.com/repos/junegunn/fzf/releases/latest | grep '"tag_name"' | sed -E 's/.*"v([^"]+)".*/\1/')

if [ -z "$LATEST_VERSION" ]; then
    echo "Error: Could not determine latest fzf version"
    exit 1
fi

echo "Latest version: $LATEST_VERSION"

# Download URL
DOWNLOAD_URL="https://github.com/junegunn/fzf/releases/download/v${LATEST_VERSION}/fzf-${LATEST_VERSION}-linux_${FZF_ARCH}.tar.gz"

# Create temp directory
TMP_DIR=$(mktemp -d)
trap "rm -rf $TMP_DIR" EXIT

# Download and extract
echo "Downloading fzf..."
curl -sL "$DOWNLOAD_URL" -o "$TMP_DIR/fzf.tar.gz"
tar -xzf "$TMP_DIR/fzf.tar.gz" -C "$TMP_DIR"

# Install to ~/.local/bin
mkdir -p "$HOME/.local/bin"
mv "$TMP_DIR/fzf" "$HOME/.local/bin/fzf"
chmod +x "$HOME/.local/bin/fzf"

# Verify installation
if "$HOME/.local/bin/fzf" --version &>/dev/null; then
    echo "fzf installed successfully!"
    echo "Version: $("$HOME/.local/bin/fzf" --version)"
else
    echo "Error: fzf installation failed"
    exit 1
fi

# Check if ~/.local/bin is in PATH
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    echo ""
    echo "Note: ~/.local/bin is not in your PATH"
    echo "Add this to your shell config: export PATH=\"\$HOME/.local/bin:\$PATH\""
fi
