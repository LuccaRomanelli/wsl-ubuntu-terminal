# Ubuntu Terminal Setup

Automated terminal environment setup for Ubuntu, featuring Zsh, Tmux, Starship, and dotfiles management.

## Features

- **Zsh**: Modern shell with Oh-My-Zsh framework
- **Oh-My-Zsh Plugins**: autosuggestions, syntax-highlighting
- **Starship**: Fast, customizable prompt
- **Tmux**: Terminal multiplexer with TPM (plugin manager)
- **Dotfiles**: Automated symlink management using GNU Stow
- **No mid-installation reboot**: All steps run continuously

## Quick Start

```bash
git clone <repo-url> ~/ubuntu-terminal-setup
cd ~/ubuntu-terminal-setup
./setup.sh
```

After installation completes, logout and login to apply shell change.

## What Gets Installed

### APT Packages
- stow (dotfiles management)
- zsh (shell)
- tmux (terminal multiplexer)
- git (version control)
- curl (downloads)
- ripgrep (fast grep alternative)
- fzf (fuzzy finder)
- fd-find (fast find alternative)
- bat (cat with syntax highlighting)
- eza (modern ls replacement)

### Shell Enhancements
- Oh-My-Zsh framework
- zsh-autosuggestions plugin
- zsh-syntax-highlighting plugin
- Starship prompt

### Configurations
Dotfiles from [LuccaRomanelli/dotfiles](https://github.com/LuccaRomanelli/dotfiles):
- zshrc
- tmux
- starship
- gitconfig
- gitconfig-gitlab

## Installation Process

1. Installs Zsh + Oh-My-Zsh + plugins
2. Installs core packages (runs in zsh)
3. Installs Starship prompt (runs in zsh)
4. Installs Tmux + TPM (runs in zsh)
5. Clones and stows dotfiles (runs in zsh)
6. Sets Zsh as default shell
7. Prompts for logout/reboot

## Manual Installation (Individual Components)

```bash
# Install specific components
./install/zsh.sh           # Just Zsh setup
./install/starship.sh      # Just Starship
./install/tmux.sh          # Just Tmux + TPM
./install/dotfiles.sh      # Just dotfiles

# Install packages
./apt/install-packages.sh  # Batch install all packages
./apt/install-package.sh <package> [binary]  # Single package
```

## Requirements

- Ubuntu 20.04 or later (tested on 22.04/24.04)
- sudo privileges
- Internet connection
- Git configured for GitHub access (SSH key for dotfiles)

## Troubleshooting

**Packages already installed?**
The installer skips packages that are already present.

**Dotfiles sync fails?**
Ensure your SSH key is configured for GitHub access.

**Want to run specific steps?**
All scripts in `install/` can be run independently.

## License

MIT
