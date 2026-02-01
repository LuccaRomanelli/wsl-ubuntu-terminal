#!/bin/bash

# Clone Obsidian vault from GitHub

VAULT_REPO="git@github.com:LuccaRomanelli/obisidian.git"
VAULT_DIR="$HOME/obsidian-vault"

if [ -d "$VAULT_DIR" ]; then
    echo "Obsidian vault already exists at $VAULT_DIR"
    echo "Pulling latest changes..."
    git -C "$VAULT_DIR" pull
else
    echo "Cloning Obsidian vault..."
    git clone "$VAULT_REPO" "$VAULT_DIR"
fi

echo "Obsidian vault ready at $VAULT_DIR"
