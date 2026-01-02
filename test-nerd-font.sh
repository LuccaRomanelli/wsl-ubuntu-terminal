#!/bin/bash

echo "=== Nerd Font Test ==="
echo ""

# Check if fonts are installed
echo "1. Checking installed fonts..."

# Check Linux fonts
if fc-list | grep -i "caskaydia" > /dev/null; then
    echo "✓ CaskaydiaMono fonts found in Linux:"
    fc-list | grep -i "caskaydia" | head -3
else
    echo "✗ CaskaydiaMono fonts NOT found in Linux"
fi

# Check Windows fonts (if in WSL)
if grep -qi microsoft /proc/version 2>/dev/null; then
    echo ""
    echo "Checking Windows fonts..."
    win_user=$(cmd.exe /c "echo %USERNAME%" 2>/dev/null | tr -d '\r\n')
    if [ -n "$win_user" ]; then
        win_fonts="/mnt/c/Users/${win_user}/AppData/Local/Microsoft/Windows/Fonts"
        if ls "$win_fonts"/Caskaydia*.ttf > /dev/null 2>&1; then
            echo "✓ CaskaydiaMono fonts found in Windows:"
            ls -1 "$win_fonts"/Caskaydia*.ttf | head -3 | xargs -n1 basename
        else
            echo "✗ CaskaydiaMono fonts NOT found in Windows"
            echo "  Windows fonts dir: $win_fonts"
        fi
    fi
fi

if ! fc-list | grep -i "caskaydia" > /dev/null && ! ls /mnt/c/Users/*/AppData/Local/Microsoft/Windows/Fonts/Caskaydia*.ttf > /dev/null 2>&1; then
    echo ""
    echo "⚠ Run: ./install/nerd-font.sh to install"
fi
echo ""

# Display current terminal info
echo "2. Terminal detection..."
if [ -n "$WT_SESSION" ] || [ -n "$WT_PROFILE_ID" ]; then
    echo "Terminal: Windows Terminal"
    echo "Session: $WT_SESSION"
elif [ "$TERM_PROGRAM" = "vscode" ]; then
    echo "Terminal: VS Code integrated terminal"
elif [ -n "$KITTY_WINDOW_ID" ]; then
    echo "Terminal: Kitty"
elif [ -n "$ALACRITTY_SOCKET" ]; then
    echo "Terminal: Alacritty"
elif [ "$COLORTERM" = "gnome-terminal" ]; then
    echo "Terminal: GNOME Terminal"
else
    echo "Terminal: $TERM (unknown type)"
fi
echo ""

# Test Nerd Font icons
echo "3. Nerd Font icon test..."
echo "If you see icons/symbols below, Nerd Font is working:"
echo ""
echo "   Folder icons:       "
echo "   Git icons:          "
echo "   Language icons:        "
echo "   OS icons:          "
echo "   Powerline symbols:        "
echo ""
echo "If you see boxes/question marks, Nerd Font is NOT active."
echo ""

# Test common programming ligatures (not Nerd Font specific, but good to check)
echo "4. Font rendering test..."
echo "   != >= <= => -> <- == === && ||"
echo ""

# Check configuration files
echo "5. Checking terminal configuration..."
echo ""

check_windows_terminal() {
    # Get Windows username
    local win_user=$(cmd.exe /c "echo %USERNAME%" 2>/dev/null | tr -d '\r\n')

    if [ -z "$win_user" ]; then
        echo "Could not detect Windows username"
        return 1
    fi

    local windows_appdata="/mnt/c/Users/${win_user}/AppData/Local/Packages"
    local wt_settings=$(find "$windows_appdata" -name "settings.json" -path "*/Microsoft.WindowsTerminal*/LocalState/*" 2>/dev/null | head -n 1)

    if [ -f "$wt_settings" ]; then
        echo "Windows Terminal config: $wt_settings"
        echo "Windows user: $win_user"
        echo ""
        if command -v jq &>/dev/null; then
            local font=$(jq -r '.profiles.defaults.font.face // "not set"' "$wt_settings")
            echo "Current font in config: $font"
        else
            echo "Font setting (install jq for better parsing):"
            grep -A 5 '"font"' "$wt_settings" | head -10 || echo "  No font setting found"
        fi
    else
        echo "Windows Terminal config file not found"
        echo "Searched in: $windows_appdata"
    fi
}

check_gnome_terminal() {
    if command -v gsettings &>/dev/null; then
        local profile=$(gsettings get org.gnome.Terminal.ProfilesList default | tr -d "'")
        if [ -n "$profile" ]; then
            echo "GNOME Terminal profile: $profile"
            echo "Font setting:"
            gsettings get org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/ font
        fi
    fi
}

check_alacritty() {
    if [ -f "$HOME/.config/alacritty/alacritty.toml" ]; then
        echo "Alacritty config: $HOME/.config/alacritty/alacritty.toml"
        echo "Font setting:"
        grep -A 3 "\[font\]" "$HOME/.config/alacritty/alacritty.toml"
    elif [ -f "$HOME/.config/alacritty/alacritty.yml" ]; then
        echo "Alacritty config: $HOME/.config/alacritty/alacritty.yml"
        echo "Font setting:"
        grep -A 5 "^font:" "$HOME/.config/alacritty/alacritty.yml"
    fi
}

check_kitty() {
    if [ -f "$HOME/.config/kitty/kitty.conf" ]; then
        echo "Kitty config: $HOME/.config/kitty/kitty.conf"
        echo "Font setting:"
        grep "font_family" "$HOME/.config/kitty/kitty.conf"
    fi
}

# Run appropriate check based on terminal
if [ -n "$WT_SESSION" ] || [ -n "$WT_PROFILE_ID" ]; then
    check_windows_terminal
elif [ "$COLORTERM" = "gnome-terminal" ]; then
    check_gnome_terminal
elif [ -n "$KITTY_WINDOW_ID" ]; then
    check_kitty
elif [ -n "$ALACRITTY_SOCKET" ]; then
    check_alacritty
else
    echo "Auto-detection failed. Checking all configurations..."
    check_windows_terminal
    check_gnome_terminal
    check_alacritty
    check_kitty
fi

echo ""
echo "=== Troubleshooting ==="
echo ""
echo "If icons don't appear:"
echo "  1. Verify font is installed: fc-list | grep -i caskaydia"
echo "  2. Check your terminal's font setting manually"
echo "  3. Restart your terminal completely (close and reopen)"
echo "  4. For Windows Terminal: Close ALL instances and reopen"
echo "  5. Run: ./install/nerd-font.sh to reconfigure"
echo ""
