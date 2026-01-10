# WSL Ubuntu Terminal Setup

Automated terminal environment setup for Ubuntu on WSL, featuring Zsh, Tmux, Starship, and dotfiles management.

## Features

- **Zsh**: Modern shell with Oh-My-Zsh framework
- **Oh-My-Zsh Plugins**: autosuggestions, syntax-highlighting
- **Starship**: Fast, customizable prompt
- **fzf**: Fuzzy finder (installed from GitHub releases for latest features)
- **Nerd Font**: CaskaydiaMono Nerd Font with icon support
- **Tmux**: Terminal multiplexer with TPM (plugin manager)
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

### Shell Enhancements
- Oh-My-Zsh framework
- zsh-autosuggestions plugin
- zsh-syntax-highlighting plugin
- Starship prompt
- fzf (from GitHub releases, supports --zsh flag)
- CaskaydiaMono Nerd Font (with icon glyphs)

### Configurations
Dotfiles from [LuccaRomanelli/dotfiles](https://github.com/LuccaRomanelli/dotfiles):
- zshrc
- tmux
- starship
- gitconfig
- gitconfig-gitlab

## Installation Process

1. Installs Zsh + Oh-My-Zsh + plugins
2. Installs core APT packages
3. Installs fzf from GitHub releases
4. Installs Neovim Kickstart
5. Installs Claude Code
6. Installs Starship prompt
7. Installs CaskaydiaMono Nerd Font
8. Installs Tmux + TPM
9. Clones and stows dotfiles
10. Sets Zsh as default shell

## Manual Installation (Individual Components)

```bash
# Install specific components
./install/zsh.sh           # Just Zsh setup
./install/fzf.sh           # Just fzf (from GitHub)
./install/starship.sh      # Just Starship
./install/nerd-font.sh     # Just Nerd Font
./install/tmux.sh          # Just Tmux + TPM
./install/dotfiles.sh      # Just dotfiles

# Install packages
./apt/install-packages.sh  # Batch install all packages
./apt/install-package.sh <package> [binary]  # Single package
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
All scripts in `install/` can be run independently.

**Font not showing up?**
Run `fc-cache -fv ~/.local/share/fonts` to refresh the font cache.

## License

MIT
