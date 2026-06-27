#!/bin/bash
# QuishesOS Configuration Validator
# Checks for common configuration issues before building ISO

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

errors=0
warnings=0

echo "=== QuishesOS Configuration Validator ==="
echo ""

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

cd "$PROJECT_ROOT"

# Check Hyprland config
echo "Checking Hyprland configuration..."
if [ -f "archiso/airootfs/etc/skel/.config/hypr/hyprland.conf" ]; then
    echo -e "${GREEN}✓${NC} hyprland.conf exists"
else
    echo -e "${RED}✗${NC} hyprland.conf missing"
    ((errors++))
fi

# Check theme configs
echo ""
echo "Checking theme configurations..."
theme_count=0
for theme in liquid_pastel nordic_frost sakura_dream forest_mist sunset_amber aurora_glass; do
    if [ -f "themes/${theme}.conf" ]; then
        ((theme_count++))
    else
        echo -e "${YELLOW}!${NC} ${theme}.conf missing"
        ((warnings++))
    fi
done
echo "Found $theme_count/6 themes"

# Check scripts are executable
echo ""
echo "Checking script permissions..."
for script in archiso/airootfs/etc/skel/.config/hypr/scripts/*.sh; do
    if [ -f "$script" ]; then
        if [ -x "$script" ]; then
            echo -e "${GREEN}✓${NC} $(basename $script) is executable"
        else
            echo -e "${YELLOW}!${NC} $(basename $script) not executable"
            chmod +x "$script"
            echo "  Fixed: set executable"
        fi
    fi
done

# Check NovaForge.nvim
echo ""
echo "Checking NovaForge.nvim configuration..."
if [ -f "archiso/airootfs/etc/skel/.config/nvim/init.lua" ]; then
    echo -e "${GREEN}✓${NC} NovaForge init.lua exists"
else
    echo -e "${RED}✗${NC} NovaForge init.lua missing"
    ((errors++))
fi

# Summary
echo ""
echo "=== Validation Summary ==="
echo "Errors: $errors"
echo "Warnings: $warnings"

if [ $errors -eq 0 ]; then
    echo -e "${GREEN}Configuration is valid!${NC}"
    exit 0
else
    echo -e "${RED}Fix errors before building ISO${NC}"
    exit 1
fi
