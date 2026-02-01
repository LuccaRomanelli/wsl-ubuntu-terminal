#!/bin/bash

# Clone a single git repository
# Usage: ./git/clone-repo.sh <repo_url> [repo_name] [branch] [post_clone_script]

set -e

# Portable way to get script directory (works in both bash and zsh)
if [ -n "$BASH_SOURCE" ]; then
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
else
    SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
fi
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

REPO_URL="${1:-}"
REPO_NAME="${2:-}"
BRANCH="${3:-main}"
POST_CLONE_SCRIPT="${4:-}"

if [ -z "$REPO_URL" ]; then
    echo "Error: REPO_URL is required"
    echo "Usage: $0 <repo_url> [repo_name] [branch] [post_clone_script]"
    exit 1
fi

# If REPO_NAME was not provided, extract from URL
if [ -z "$REPO_NAME" ]; then
    REPO_NAME="$(basename "$REPO_URL" .git)"
fi

# Determine target directory
if [[ "$REPO_NAME" == .* ]]; then
    # If repo_name starts with ., it's a relative path from HOME
    TARGET_DIR="$HOME/$REPO_NAME"
else
    TARGET_DIR="$HOME/$REPO_NAME"
fi

# Use lib/git_sync_repo.sh to clone (with FORCE_PULL=false for clone-only)
"$ROOT_DIR/lib/git_sync_repo.sh" "$REPO_URL" "$REPO_NAME" "$BRANCH" "$HOME" "false"

# Run post-clone script if specified
if [ -n "$POST_CLONE_SCRIPT" ] && [ -f "$TARGET_DIR/$POST_CLONE_SCRIPT" ]; then
    echo "Running post-clone script: $POST_CLONE_SCRIPT"
    cd "$TARGET_DIR"
    bash "$POST_CLONE_SCRIPT"
fi
