#!/bin/bash

set -e

# Check if lazygit is already installed
if command -v lazygit &>/dev/null; then
    echo "lazygit is already installed"
    echo "Current version: $(lazygit --version | head -n1)"
    exit 0
fi

echo "Installing lazygit from GitHub releases..."

# Detect architecture
ARCH=$(uname -m)
case "$ARCH" in
    x86_64)
        LAZYGIT_ARCH="x86_64"
        ;;
    aarch64|arm64)
        LAZYGIT_ARCH="arm64"
        ;;
    *)
        echo "Error: Unsupported architecture: $ARCH"
        exit 1
        ;;
esac

# Get latest release version from GitHub API
LATEST_VERSION=$(curl -sS https://api.github.com/repos/jesseduffield/lazygit/releases/latest | grep '"tag_name"' | sed -E 's/.*"v([^"]+)".*/\1/')

if [ -z "$LATEST_VERSION" ]; then
    echo "Error: Could not determine latest lazygit version"
    exit 1
fi

echo "Latest version: $LATEST_VERSION"

# Download URL
DOWNLOAD_URL="https://github.com/jesseduffield/lazygit/releases/download/v${LATEST_VERSION}/lazygit_${LATEST_VERSION}_Linux_${LAZYGIT_ARCH}.tar.gz"

# Create temp directory
TMP_DIR=$(mktemp -d)
trap "rm -rf $TMP_DIR" EXIT

# Download and extract
echo "Downloading lazygit..."
curl -sL "$DOWNLOAD_URL" -o "$TMP_DIR/lazygit.tar.gz"
tar -xzf "$TMP_DIR/lazygit.tar.gz" -C "$TMP_DIR"

# Install to ~/.local/bin
mkdir -p "$HOME/.local/bin"
mv "$TMP_DIR/lazygit" "$HOME/.local/bin/lazygit"
chmod +x "$HOME/.local/bin/lazygit"

# Verify installation
if "$HOME/.local/bin/lazygit" --version &>/dev/null; then
    echo "lazygit installed successfully!"
    echo "Version: $("$HOME/.local/bin/lazygit" --version | head -n1)"
else
    echo "Error: lazygit installation failed"
    exit 1
fi

# Check if ~/.local/bin is in PATH
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    echo ""
    echo "Note: ~/.local/bin is not in your PATH"
    echo "Add this to your shell config: export PATH=\"\$HOME/.local/bin:\$PATH\""
fi
