# Ubuntu Terminal Setup

Modular infrastructure for setting up a development terminal on Ubuntu/WSL.

## Directory Structure

```
wsl-ubuntu-terminal/
├── setup.sh              # Main entry point for fresh installation
├── update.sh             # Update all packages and repositories
├── apt/                  # APT package management
│   ├── packages.list     # List of APT packages
│   ├── install-package.sh
│   ├── install-packages.sh
│   ├── update-package.sh
│   └── update-packages.sh
├── curl/                 # Curl-based installers
│   ├── packages.list     # Format: <name> <check_command> <install_url>
│   ├── install-package.sh
│   ├── install-packages.sh
│   ├── update-package.sh
│   └── update-packages.sh
├── npm/                  # NPM global packages
│   ├── packages.list     # Format: <package_name> <check_command>
│   ├── install-package.sh
│   ├── install-packages.sh
│   ├── update-package.sh
│   └── update-packages.sh
├── github-releases/      # GitHub releases packages
│   ├── packages.list     # Format: <name> <repo> <binary_name>
│   ├── install-package.sh
│   ├── install-packages.sh
│   ├── update-package.sh
│   └── update-packages.sh
├── git/                  # Git repository management
│   ├── repos.list        # Format: <repo_url> [repo_name] [branch] [post_clone_script]
│   ├── clone-repo.sh
│   ├── clone-repos.sh
│   ├── sync-repo.sh
│   └── sync-repos.sh
├── install/              # Complex installers (not easily batch-able)
│   ├── zsh.sh            # Oh-My-Zsh + plugins
│   ├── tmux.sh           # Tmux + TPM
│   └── nerd-font.sh      # Nerd Font installation
├── uninstall/
│   └── all.sh            # Uninstall everything
└── lib/
    ├── git_sync_repo.sh  # Git sync utility with FORCE_PULL support
    └── set-shell.sh      # Set default shell to zsh
```

## Package List Formats

### apt/packages.list
```
# Format: package_name [binary_name]
neovim nvim
ripgrep rg
fd-find fdfind
bat batcat
```

### curl/packages.list
```
# Format: <name> <check_command> <install_url>
mise mise https://mise.run
starship starship https://starship.rs/install.sh
nhost nhost https://raw.githubusercontent.com/nhost/cli/main/get.sh
rclone rclone https://rclone.org/install.sh
```

### npm/packages.list
```
# Format: <package_name> <check_command>
@anthropic-ai/claude-code claude
@devcontainers/cli devcontainer
```

### github-releases/packages.list
```
# Format: <name> <repo> <binary_name>
fzf junegunn/fzf fzf
yazi sxyazi/yazi yazi
zoxide ajeetdsouza/zoxide zoxide
lazygit jesseduffield/lazygit lazygit
```

### git/repos.list
```
# Format: <repo_url> [repo_name] [branch] [post_clone_script]
git@github.com:user/dotfiles.git dotfiles main setup.sh
git@github.com:user/kickstart.nvim.git .config/nvim main
```

## lib/git_sync_repo.sh

Utility for cloning and syncing git repositories.

```bash
# Usage: ./git_sync_repo.sh <REPO_URL> [REPO_NAME] [BRANCH] [BASE_DIR] [FORCE_PULL]
# - REPO_URL: required
# - REPO_NAME: optional (default: name from URL)
# - BRANCH: optional (default: main)
# - BASE_DIR: optional (default: $HOME)
# - FORCE_PULL: optional (default: false) - if true, pull even if repo exists
```

When `FORCE_PULL=false` (default):
- If repo exists, skip
- If repo doesn't exist, clone

When `FORCE_PULL=true`:
- If repo exists, fetch and pull
- If repo doesn't exist, clone

## Common Tasks

### Fresh Installation
```bash
./setup.sh
```

### Update Everything
```bash
./update.sh
```

### Add a New APT Package
1. Add to `apt/packages.list`
2. Run `./apt/install-packages.sh`

### Add a New Curl Package
1. Add to `curl/packages.list` with format: `name check_cmd install_url`
2. Run `./curl/install-packages.sh`

### Add a New NPM Package
1. Add to `npm/packages.list` with format: `package_name check_cmd`
2. Run `./npm/install-packages.sh`

### Add a New GitHub Release Package
1. Add to `github-releases/packages.list` with format: `name repo binary_name`
2. Update `github-releases/install-package.sh` with download URL pattern if needed
3. Run `./github-releases/install-packages.sh`

### Add a New Git Repository
1. Add to `git/repos.list` with format: `repo_url [repo_name] [branch] [post_clone_script]`
2. Run `./git/clone-repos.sh`

### Sync All Repositories
```bash
./git/sync-repos.sh
```

## Idempotency

All scripts are idempotent:
- They check if packages are already installed before installing
- `setup.sh` can be re-run to add missing packages
- `update.sh` only updates what's already installed

## Binaries Location

Most binaries are installed to `~/.local/bin`. Make sure this is in your PATH:
```bash
export PATH="$HOME/.local/bin:$PATH"
```
