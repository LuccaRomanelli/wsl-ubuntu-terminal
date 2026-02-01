#!/bin/bash

# Clone shell scripts from GitHub

SHELL_REPO="git@github.com:LuccaRomanelli/shell.git"
SHELL_DIR="$HOME/shell"

if [ -d "$SHELL_DIR" ]; then
    echo "Shell scripts already exist at $SHELL_DIR"
    echo "Pulling latest changes..."
    git -C "$SHELL_DIR" pull
else
    echo "Cloning shell scripts..."
    git clone "$SHELL_REPO" "$SHELL_DIR"
fi

# Make all .sh files executable
if [ -d "$SHELL_DIR" ]; then
    find "$SHELL_DIR" -name "*.sh" -exec chmod +x {} \;
    echo "Made all .sh files executable"
fi

echo "Shell scripts ready at $SHELL_DIR"
echo "Note: PATH should be configured in your .zsh_alias"
