#!/bin/bash

set -e

# Portable way to get script directory (works in both bash and zsh)
if [ -n "$BASH_SOURCE" ]; then
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
else
    SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
fi
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

# Font configuration
FONT_NAME="CascadiaMono"
FONT_VERSION="v3.4.0"
DOWNLOAD_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/${FONT_VERSION}/${FONT_NAME}.zip"
TEMP_DIR="/tmp/nerd-font-install"
FONTS_DIR="$HOME/.local/share/fonts"

# Check if font is already installed (idempotency check)
if ls "$FONTS_DIR"/CaskaydiaMono*.ttf &>/dev/null 2>&1; then
    echo "${FONT_NAME} Nerd Font is already installed"
    exit 0
fi

echo "Installing ${FONT_NAME} Nerd Font..."

# Install required packages
"$ROOT_DIR/apt/install-package.sh" wget
"$ROOT_DIR/apt/install-package.sh" unzip
"$ROOT_DIR/apt/install-package.sh" fontconfig fc-cache
"$ROOT_DIR/apt/install-package.sh" jq

# Detect environment (WSL vs native Linux)
IS_WSL=false
if grep -qi microsoft /proc/version 2>/dev/null; then
    IS_WSL=true
    echo "Detected WSL environment"
fi

# Create temp directory
mkdir -p "$TEMP_DIR"

# Download the font
echo "Downloading ${FONT_NAME} Nerd Font..."
cd "$TEMP_DIR"
wget -q --show-progress "$DOWNLOAD_URL" -O "${FONT_NAME}.zip"

# Extract the font
echo "Extracting font files..."
unzip -q -o "${FONT_NAME}.zip" -d "$FONT_NAME"

# Install fonts based on environment
if [ "$IS_WSL" = true ]; then
    # Get Windows username
    WIN_USER=$(cmd.exe /c "echo %USERNAME%" 2>/dev/null | tr -d '\r\n')

    if [ -n "$WIN_USER" ]; then
        # Install to Windows fonts directory
        WIN_FONTS_DIR="/mnt/c/Users/${WIN_USER}/AppData/Local/Microsoft/Windows/Fonts"

        echo "Installing fonts to Windows (user: $WIN_USER)..."
        mkdir -p "$WIN_FONTS_DIR"

        # Copy TTF files to Windows fonts directory
        find "$FONT_NAME" -name "*.ttf" -not -name "*Windows*" -exec cp -v {} "$WIN_FONTS_DIR/" \;

        echo "Fonts installed to: $WIN_FONTS_DIR"
        echo ""
        echo "Note: Fonts installed to Windows user font directory."
        echo "If fonts don't appear, you may need to install them manually:"
        echo "  1. Open: $WIN_FONTS_DIR"
        echo "  2. Right-click each .ttf file and select 'Install for all users'"
    else
        echo "Warning: Could not detect Windows username"
        echo "Falling back to Linux installation..."
        IS_WSL=false
    fi
fi

# Also install to Linux (for apps running in WSL)
if [ "$IS_WSL" = true ]; then
    echo "Also installing fonts to WSL Linux..."
fi

mkdir -p "$FONTS_DIR"

echo "Installing font files to Linux..."
find "$FONT_NAME" -name "*.ttf" -not -name "*Windows*" -exec cp {} "$FONTS_DIR/" \;

# Update font cache
echo "Updating Linux font cache..."
fc-cache -fv "$FONTS_DIR" > /dev/null 2>&1

# Cleanup
echo "Cleaning up..."
rm -rf "$TEMP_DIR"

echo "${FONT_NAME} Nerd Font installed successfully!"
echo ""

# Auto-configure terminal font
configure_terminal_font() {
    local font_configured=false

    # Detect and configure Windows Terminal (most common in WSL)
    if [ -n "$WT_SESSION" ] || [ -n "$WT_PROFILE_ID" ]; then
        echo "Detected Windows Terminal"
        configure_windows_terminal && font_configured=true
    fi

    # Detect and configure GNOME Terminal
    if command -v gsettings &>/dev/null && [ "$XDG_CURRENT_DESKTOP" = "GNOME" ]; then
        echo "Detected GNOME Terminal"
        configure_gnome_terminal && font_configured=true
    fi

    # Detect and configure Alacritty
    if [ -f "$HOME/.config/alacritty/alacritty.yml" ] || [ -f "$HOME/.config/alacritty/alacritty.toml" ]; then
        echo "Detected Alacritty configuration"
        configure_alacritty && font_configured=true
    fi

    # Detect and configure Kitty
    if [ -f "$HOME/.config/kitty/kitty.conf" ]; then
        echo "Detected Kitty configuration"
        configure_kitty && font_configured=true
    fi

    if [ "$font_configured" = false ]; then
        echo "Could not auto-configure terminal font."
        echo ""
        echo "To use this font in your terminal:"
        echo "  1. Open your terminal preferences/settings"
        echo "  2. Look for 'Font' or 'Appearance' settings"
        echo "  3. Select 'CaskaydiaMono Nerd Font' as your terminal font"
    fi
}

configure_windows_terminal() {
    # Check if jq is installed
    if ! command -v jq &>/dev/null; then
        echo "Error: jq is not installed. Cannot configure Windows Terminal automatically."
        echo "Please install jq and run this script again, or configure the font manually."
        return 1
    fi

    # Get Windows username
    local win_user=$(cmd.exe /c "echo %USERNAME%" 2>/dev/null | tr -d '\r\n')

    if [ -z "$win_user" ]; then
        echo "Could not detect Windows username"
        return 1
    fi

    # Windows Terminal settings file location
    local windows_appdata="/mnt/c/Users/${win_user}/AppData/Local/Packages"
    local wt_settings=$(find "$windows_appdata" -name "settings.json" -path "*/Microsoft.WindowsTerminal*/LocalState/*" 2>/dev/null | head -n 1)

    if [ -f "$wt_settings" ]; then
        echo "Configuring Windows Terminal..."
        echo "Settings file: $wt_settings"

        # Backup original settings
        local backup_timestamp=$(date +%Y%m%d_%H%M%S)
        local backup_file="${wt_settings}.backup.${backup_timestamp}"
        cp "$wt_settings" "$backup_file"

        # Update font using jq
        # Ensure profiles.defaults.font structure exists and set face
        local temp_file="${wt_settings}.tmp"
        jq '.profiles.defaults = (.profiles.defaults // {}) | .profiles.defaults.font = (.profiles.defaults.font // {}) | .profiles.defaults.font.face = "CaskaydiaMono Nerd Font"' "$wt_settings" > "$temp_file"

        if [ $? -eq 0 ] && [ -s "$temp_file" ]; then
            mv "$temp_file" "$wt_settings"
            echo "✓ Windows Terminal configured successfully!"
            echo "  Font set to: CaskaydiaMono Nerd Font"
            echo "  Backup saved: $backup_file"
            echo ""
            echo "IMPORTANT: Close ALL Windows Terminal windows and reopen for changes to take effect!"
            return 0
        else
            echo "Error: Failed to update settings file"
            rm -f "$temp_file"
            return 1
        fi
    else
        echo "Windows Terminal settings file not found"
        echo "Searched in: $windows_appdata"
        return 1
    fi
}

configure_gnome_terminal() {
    # Get the default profile UUID
    local profile=$(gsettings get org.gnome.Terminal.ProfilesList default | tr -d "'")

    if [ -n "$profile" ]; then
        echo "Configuring GNOME Terminal..."

        # Set custom font
        gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/ use-system-font false
        gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/ font 'CaskaydiaMono Nerd Font 11'

        echo "✓ GNOME Terminal configured successfully!"
        echo "  Font set to: CaskaydiaMono Nerd Font 11"
        return 0
    else
        echo "Could not find GNOME Terminal profile"
        return 1
    fi
}

configure_alacritty() {
    local config_yml="$HOME/.config/alacritty/alacritty.yml"
    local config_toml="$HOME/.config/alacritty/alacritty.toml"

    if [ -f "$config_toml" ]; then
        echo "Configuring Alacritty (TOML)..."

        # Backup original config
        cp "$config_toml" "${config_toml}.backup"

        # Add or update font configuration
        if grep -q "^\[font\]" "$config_toml"; then
            # Update existing font section
            sed -i '/^\[font\]/,/^\[/ s/^family = .*/family = "CaskaydiaMono Nerd Font"/' "$config_toml"
        else
            # Add new font section
            echo -e "\n[font]\nfamily = \"CaskaydiaMono Nerd Font\"" >> "$config_toml"
        fi

        echo "✓ Alacritty configured successfully!"
        echo "  Backup saved: ${config_toml}.backup"
        return 0

    elif [ -f "$config_yml" ]; then
        echo "Configuring Alacritty (YAML)..."

        # Backup original config
        cp "$config_yml" "${config_yml}.backup"

        # Add or update font configuration
        if grep -q "^font:" "$config_yml"; then
            # Update existing font section
            sed -i '/^font:/,/^[^ ]/ s/family: .*/family: CaskaydiaMono Nerd Font/' "$config_yml"
        else
            # Add new font section
            echo -e "\nfont:\n  normal:\n    family: CaskaydiaMono Nerd Font" >> "$config_yml"
        fi

        echo "✓ Alacritty configured successfully!"
        echo "  Backup saved: ${config_yml}.backup"
        return 0
    else
        return 1
    fi
}

configure_kitty() {
    local config="$HOME/.config/kitty/kitty.conf"

    echo "Configuring Kitty..."

    # Backup original config
    cp "$config" "${config}.backup"

    # Add or update font configuration
    if grep -q "^font_family" "$config"; then
        sed -i 's/^font_family.*/font_family CaskaydiaMono Nerd Font/' "$config"
    else
        echo "font_family CaskaydiaMono Nerd Font" >> "$config"
    fi

    echo "✓ Kitty configured successfully!"
    echo "  Backup saved: ${config}.backup"
    return 0
}

echo "Attempting to auto-configure terminal font..."
configure_terminal_font
echo ""
