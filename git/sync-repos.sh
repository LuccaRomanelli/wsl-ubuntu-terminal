#!/bin/bash

# Batch sync (pull) for git repositories

set -e

# Portable way to get script directory (works in both bash and zsh)
if [ -n "$BASH_SOURCE" ]; then
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
else
    SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
fi
LIST_FILE="$SCRIPT_DIR/repos.list"

if [ ! -f "$LIST_FILE" ]; then
    echo "Error: Repository list file not found: $LIST_FILE"
    exit 1
fi

echo "Syncing repositories from $LIST_FILE..."
echo

while IFS= read -r line || [ -n "$line" ]; do
    # Skip empty lines and comments
    [[ -z "$line" || "$line" =~ ^# ]] && continue

    # Parse: repo_url [repo_name] [branch] [post_clone_script]
    read -r repo_url repo_name branch _post_clone_script <<< "$line"

    "$SCRIPT_DIR/sync-repo.sh" "$repo_url" "$repo_name" "${branch:-main}"
    echo
done < "$LIST_FILE"

echo "Repository sync complete!"
