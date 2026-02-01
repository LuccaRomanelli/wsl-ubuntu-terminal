#!/bin/bash

# Sync (pull) a single git repository
# Usage: ./git/sync-repo.sh <repo_url> [repo_name] [branch]

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

if [ -z "$REPO_URL" ]; then
    echo "Error: REPO_URL is required"
    echo "Usage: $0 <repo_url> [repo_name] [branch]"
    exit 1
fi

# If REPO_NAME was not provided, extract from URL
if [ -z "$REPO_NAME" ]; then
    REPO_NAME="$(basename "$REPO_URL" .git)"
fi

# Use lib/git_sync_repo.sh with FORCE_PULL=true
"$ROOT_DIR/lib/git_sync_repo.sh" "$REPO_URL" "$REPO_NAME" "$BRANCH" "$HOME" "true"
