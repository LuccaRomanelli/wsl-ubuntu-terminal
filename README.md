# WSL Ubuntu Terminal Setup

Automated terminal environment setup for Ubuntu on WSL, featuring Zsh, Tmux, Starship, and dotfiles management.

## Features

- **Zsh**: Modern shell with Oh-My-Zsh framework
- **Oh-My-Zsh Plugins**: autosuggestions, syntax-highlighting
- **Starship**: Fast, customizable prompt
- **fzf**: Fuzzy finder (installed from GitHub releases)
- **Nerd Font**: CaskaydiaMono Nerd Font with icon support
- **Tmux**: Terminal multiplexer with TPM (plugin manager)
- **Neovim**: Modern editor with Kickstart configuration
- **Dotfiles**: Automated symlink management using GNU Stow
- **No mid-installation reboot**: All steps run continuously

## Quick Start

```bash
git clone <repo-url> ~/wsl-ubuntu-terminal
cd ~/wsl-ubuntu-terminal
./setup.sh
```

After installation completes:
1. Restart your terminal to apply the font changes
2. Logout and login to apply the shell change

## What Gets Installed

### APT Packages
- stow (dotfiles management)
- zsh (shell)
- tmux (terminal multiplexer)
- git (version control)
- curl (downloads)
- ripgrep (fast grep alternative)
- fd-find (fast find alternative)
- bat (cat with syntax highlighting)
- eza (modern ls replacement)
- make, gcc, unzip (build tools)
- xclip (clipboard utility)
- neovim (modern editor)
- pandoc, texlive-xetex, texlive-fonts-recommended, fonts-dejavu (MD to PDF conversion)
- mutt (email client)
- jq (JSON processor)
- w3m (text browser)

### GitHub Releases
- fzf (fuzzy finder)
- yazi (modern terminal file manager)
- zoxide (smart cd that learns your habits)
- lazygit (interactive Git TUI)

### Curl Installers
- mise (polyglot version manager for node, python, etc.)
- starship (cross-shell prompt)
- nhost (Nhost CLI)
- rclone (cloud storage sync)

### NPM Global Packages
- claude-code (Claude AI CLI)
- devcontainer (Dev Containers CLI)

### Configurations
Dotfiles from [LuccaRomanelli/dotfiles](https://github.com/LuccaRomanelli/dotfiles):
- zshrc
- tmux
- starship
- gitconfig

### Personal Repositories
- Dotfiles from [LuccaRomanelli/dotfiles](https://github.com/LuccaRomanelli/dotfiles)
- Shell scripts from [LuccaRomanelli/shell](https://github.com/LuccaRomanelli/shell)
- Obsidian vault from [LuccaRomanelli/obisidian](https://github.com/LuccaRomanelli/obisidian)
- Neovim Kickstart from [LuccaRomanelli/kickstart.nvim](https://github.com/LuccaRomanelli/kickstart.nvim)

## Installation Process

1. Installs Zsh + Oh-My-Zsh + plugins
2. Installs APT packages
3. Installs GitHub releases packages (fzf, yazi, zoxide, lazygit)
4. Installs curl-based packages (mise, starship, nhost, rclone)
5. Installs NPM packages (claude-code, devcontainer)
6. Installs CaskaydiaMono Nerd Font
7. Installs Tmux + TPM
8. Clones git repositories (dotfiles, nvim, shell, obsidian)
9. Sets Zsh as default shell

## Manual Installation (Individual Components)

```bash
# Complex installers
./install/zsh.sh             # Zsh + Oh-My-Zsh + plugins
./install/nerd-font.sh       # CaskaydiaMono Nerd Font
./install/tmux.sh            # Tmux + TPM

# Batch installers
./apt/install-packages.sh              # All APT packages
./github-releases/install-packages.sh  # All GitHub releases
./curl/install-packages.sh             # All curl packages
./npm/install-packages.sh              # All NPM packages
./git/clone-repos.sh                   # All git repositories

# Single package installers
./apt/install-package.sh <package> [binary]
./github-releases/install-package.sh <name>
./curl/install-package.sh <name>
./npm/install-package.sh <package>
./git/clone-repo.sh <repo_url> [name] [branch] [post_script]
```

## Update Everything

```bash
./update.sh
```

## Requirements

- WSL2 with Ubuntu 20.04 or later (tested on 22.04/24.04)
- sudo privileges
- Internet connection
- Git configured for GitHub access (SSH key for dotfiles)

## Post-Installation

### Terminal Font

The installer automatically configures the font for supported terminals:
- **Windows Terminal** (auto-configured)
- **GNOME Terminal** (auto-configured)
- **Alacritty** (auto-configured)
- **Kitty** (auto-configured)

If your terminal wasn't auto-configured, manually select **CaskaydiaMono Nerd Font Mono** in your terminal settings.

Available font variants:
- CaskaydiaMono Nerd Font
- CaskaydiaMono Nerd Font Mono (recommended for terminal)
- CaskaydiaMono Nerd Font Propo

## Troubleshooting

**Packages already installed?**
The installer skips packages that are already present.

**Dotfiles sync fails?**
Ensure your SSH key is configured for GitHub access.

**Want to run specific steps?**
All scripts in `install/`, `apt/`, `curl/`, `npm/`, `github-releases/`, and `git/` can be run independently.

**Font not showing up?**
Run `fc-cache -fv ~/.local/share/fonts` to refresh the font cache.

## License

MIT
