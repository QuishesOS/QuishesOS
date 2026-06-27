#!/bin/bash
# QuishesOS Theme Switcher
# Switches between 6 themes with Super+T keybinding

THEME_DIR="$HOME/.config/hypr/themes"
CURRENT_THEME_FILE="$HOME/.config/hypr/theme.conf"
WALLPAPER_DIR="$HOME/Pictures/wallpapers"

# Theme list
THEMES=(
    "liquid_pastel:Liquid Pastel"
    "nordic_frost:Nordic Frost"
    "sakura_dream:Sakura Dream"
    "forest_mist:Forest Mist"
    "sunset_amber:Sunset Amber"
    "aurora_glass:Aurora Glass"
)

# Build rofi menu
menu=""
for theme in "${THEMES[@]}"; do
    theme_id="${theme%%:*}"
    theme_name="${theme##*:}"
    menu+="$theme_name\n"
done

# Show rofi selector
selected=$(echo -e "$menu" | rofi -dmenu -i -p "Select Theme" -theme ~/.config/rofi/quishesOS.rasi)

# Exit if cancelled
if [ -z "$selected" ]; then
    exit 0
fi

# Find theme ID from selected name
theme_id=""
for theme in "${THEMES[@]}"; do
    theme_name="${theme##*:}"
    if [ "$theme_name" = "$selected" ]; then
        theme_id="${theme%%:*}"
        break
    fi
done

# Verify theme exists
if [ ! -f "/usr/share/quishesos/themes/${theme_id}.conf" ]; then
    notify-send "QuishesOS Theme" "Theme file not found: ${theme_id}.conf" -u critical
    exit 1
fi

# Copy theme to current
cp "/usr/share/quishesos/themes/${theme_id}.conf" "$CURRENT_THEME_FILE"

# Change wallpaper if exists
if [ -f "$WALLPAPER_DIR/${theme_id}.jpg" ]; then
    hyprctl hyprpaper preload "$WALLPAPER_DIR/${theme_id}.jpg"
    hyprctl hyprpaper wallpaper ",$WALLPAPER_DIR/${theme_id}.jpg"
fi

# Reload Hyprland
hyprctl reload

# Update eww colors (if eww is running)
if pgrep -x eww >/dev/null; then
    # Reload eww with new theme colors
    eww reload
fi

# Notify user
notify-send "QuishesOS Theme" "Theme changed to: $selected" -u normal -t 3000

exit 0
