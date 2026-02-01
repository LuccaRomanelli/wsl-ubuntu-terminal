#!/bin/bash

# Install a single package from GitHub releases
# Usage: ./github-releases/install-package.sh <name> <repo> <binary_name>

set -e

PACKAGE_NAME="${1:-}"
REPO="${2:-}"
BINARY_NAME="${3:-}"

if [ -z "$PACKAGE_NAME" ] || [ -z "$REPO" ] || [ -z "$BINARY_NAME" ]; then
    echo "Error: Missing required arguments"
    echo "Usage: $0 <name> <repo> <binary_name>"
    exit 1
fi

# Check if already installed
if command -v "$BINARY_NAME" &>/dev/null; then
    echo "$PACKAGE_NAME is already installed"
    exit 0
fi

echo "Installing $PACKAGE_NAME from GitHub releases..."

# Detect architecture
ARCH=$(uname -m)
case "$ARCH" in
    x86_64)
        ARCH_AMD="amd64"
        ARCH_X86="x86_64"
        ;;
    aarch64|arm64)
        ARCH_AMD="arm64"
        ARCH_X86="aarch64"
        ;;
    *)
        echo "Error: Unsupported architecture: $ARCH"
        exit 1
        ;;
esac

# Get latest release version from GitHub API
LATEST_VERSION=$(curl -sS "https://api.github.com/repos/$REPO/releases/latest" | grep '"tag_name"' | sed -E 's/.*"v?([^"]+)".*/\1/')

if [ -z "$LATEST_VERSION" ]; then
    echo "Error: Could not determine latest $PACKAGE_NAME version"
    exit 1
fi

echo "Latest version: $LATEST_VERSION"

# Create temp directory
TMP_DIR=$(mktemp -d)
trap "rm -rf $TMP_DIR" EXIT

# Determine download URL and extraction method based on package
case "$PACKAGE_NAME" in
    fzf)
        DOWNLOAD_URL="https://github.com/$REPO/releases/download/v${LATEST_VERSION}/fzf-${LATEST_VERSION}-linux_${ARCH_AMD}.tar.gz"
        curl -sL "$DOWNLOAD_URL" -o "$TMP_DIR/package.tar.gz"
        tar -xzf "$TMP_DIR/package.tar.gz" -C "$TMP_DIR"
        BINARY_PATH="$TMP_DIR/fzf"
        ;;
    yazi)
        DOWNLOAD_URL="https://github.com/$REPO/releases/download/v${LATEST_VERSION}/yazi-${ARCH_X86}-unknown-linux-gnu.zip"
        curl -sL "$DOWNLOAD_URL" -o "$TMP_DIR/package.zip"
        unzip -q "$TMP_DIR/package.zip" -d "$TMP_DIR"
        BINARY_PATH="$TMP_DIR/yazi-${ARCH_X86}-unknown-linux-gnu/yazi"
        # Also install ya helper
        mkdir -p "$HOME/.local/bin"
        mv "$TMP_DIR/yazi-${ARCH_X86}-unknown-linux-gnu/ya" "$HOME/.local/bin/ya"
        chmod +x "$HOME/.local/bin/ya"
        ;;
    zoxide)
        DOWNLOAD_URL="https://github.com/$REPO/releases/download/v${LATEST_VERSION}/zoxide-${LATEST_VERSION}-${ARCH_X86}-unknown-linux-musl.tar.gz"
        curl -sL "$DOWNLOAD_URL" -o "$TMP_DIR/package.tar.gz"
        tar -xzf "$TMP_DIR/package.tar.gz" -C "$TMP_DIR"
        BINARY_PATH="$TMP_DIR/zoxide"
        ;;
    lazygit)
        DOWNLOAD_URL="https://github.com/$REPO/releases/download/v${LATEST_VERSION}/lazygit_${LATEST_VERSION}_Linux_${ARCH_X86}.tar.gz"
        curl -sL "$DOWNLOAD_URL" -o "$TMP_DIR/package.tar.gz"
        tar -xzf "$TMP_DIR/package.tar.gz" -C "$TMP_DIR"
        BINARY_PATH="$TMP_DIR/lazygit"
        ;;
    *)
        echo "Error: Unknown package: $PACKAGE_NAME"
        exit 1
        ;;
esac

# Install to ~/.local/bin
mkdir -p "$HOME/.local/bin"
mv "$BINARY_PATH" "$HOME/.local/bin/$BINARY_NAME"
chmod +x "$HOME/.local/bin/$BINARY_NAME"

# Verify installation
if "$HOME/.local/bin/$BINARY_NAME" --version &>/dev/null; then
    echo "$PACKAGE_NAME installed successfully!"
else
    echo "Warning: $PACKAGE_NAME installation may have issues"
fi

# Check if ~/.local/bin is in PATH
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    echo ""
    echo "Note: ~/.local/bin is not in your PATH"
    echo "Add this to your shell config: export PATH=\"\$HOME/.local/bin:\$PATH\""
fi
