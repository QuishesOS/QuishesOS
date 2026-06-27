#!/bin/bash
# QuishesOS Theme Manager
# Switch between 6 color themes

THEME_DIR="$HOME/.config/QuishesOS/themes"
EWW_CONFIG="$HOME/.config/eww"
CURRENT_THEME_FILE="$HOME/.config/QuishesOS/current_theme"

# Available themes
THEMES=(
    "liquid-pastel"
    "nordic-frost"
    "sakura-dream"
    "forest-mist"
    "sunset-amber"
    "aurora-glass"
)

# Theme descriptions
declare -A THEME_DESC=(
    ["liquid-pastel"]="Liquid Pastel - Soft coral/peach gradients (Default)"
    ["nordic-frost"]="Nordic Frost - Ice blue minimalism"
    ["sakura-dream"]="Sakura Dream - Cherry blossom pink"
    ["forest-mist"]="Forest Mist - Sage green tranquility"
    ["sunset-amber"]="Sunset Amber - Warm orange glow"
    ["aurora-glass"]="Aurora Glass - Dark holographic iridescent"
)

# Get current theme
get_current_theme() {
    if [ -f "$CURRENT_THEME_FILE" ]; then
        cat "$CURRENT_THEME_FILE"
    else
        echo "liquid-pastel"
    fi
}

# Set theme
set_theme() {
    local theme=$1
    
    # Validate theme
    if [[ ! " ${THEMES[@]} " =~ " ${theme} " ]]; then
        echo "Error: Invalid theme '$theme'"
        echo "Available themes:"
        for t in "${THEMES[@]}"; do
            echo "  - $t: ${THEME_DESC[$t]}"
        done
        exit 1
    fi
    
    # Update eww theme variable
    eww update theme="$theme"
    
    # Save current theme
    echo "$theme" > "$CURRENT_THEME_FILE"
    
    # Apply theme-specific configurations
    case $theme in
        aurora-glass)
            # Dark theme - adjust Hyprland opacity for darker windows
            hyprctl keyword decoration:active_opacity 0.85
            hyprctl keyword decoration:inactive_opacity 0.75
            ;;
        *)
            # Light themes - standard opacity
            hyprctl keyword decoration:active_opacity 0.96
            hyprctl keyword decoration:inactive_opacity 0.88
            ;;
    esac
    
    # Reload eww windows to apply theme
    eww reload
    
    echo "Theme changed to: ${THEME_DESC[$theme]}"
    
    # Send notification
    notify-send "QuishesOS Theme" "Applied ${THEME_DESC[$theme]}" -i preferences-desktop-theme
}

# List all themes
list_themes() {
    local current=$(get_current_theme)
    echo "Available themes:"
    echo
    for theme in "${THEMES[@]}"; do
        if [ "$theme" = "$current" ]; then
            echo "  ✓ $theme: ${THEME_DESC[$theme]} (ACTIVE)"
        else
            echo "    $theme: ${THEME_DESC[$theme]}"
        fi
    done
}

# Interactive menu
interactive_menu() {
    local current=$(get_current_theme)
    
    echo "QuishesOS Theme Manager"
    echo "======================="
    echo
    echo "Current theme: ${THEME_DESC[$current]}"
    echo
    echo "Select a theme:"
    
    local i=1
    for theme in "${THEMES[@]}"; do
        echo "  $i) ${THEME_DESC[$theme]}"
        ((i++))
    done
    echo "  0) Exit"
    echo
    
    read -p "Enter choice [0-${#THEMES[@]}]: " choice
    
    if [ "$choice" = "0" ]; then
        exit 0
    elif [ "$choice" -ge 1 ] && [ "$choice" -le "${#THEMES[@]}" ]; then
        local selected_theme="${THEMES[$((choice-1))]}"
        set_theme "$selected_theme"
    else
        echo "Invalid choice"
        exit 1
    fi
}

# Main
case "${1:-interactive}" in
    list)
        list_themes
        ;;
    set)
        if [ -z "$2" ]; then
            echo "Usage: $0 set <theme-name>"
            list_themes
            exit 1
        fi
        set_theme "$2"
        ;;
    get)
        get_current_theme
        ;;
    interactive)
        interactive_menu
        ;;
    *)
        echo "QuishesOS Theme Manager"
        echo
        echo "Usage:"
        echo "  $0 list              - List all available themes"
        echo "  $0 set <theme>       - Set a specific theme"
        echo "  $0 get               - Get current theme"
        echo "  $0 interactive       - Interactive theme selector (default)"
        echo
        echo "Available themes:"
        for theme in "${THEMES[@]}"; do
            echo "  - $theme"
        done
        exit 1
        ;;
esac
