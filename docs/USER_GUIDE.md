# QuishesOS User Guide

Welcome to QuishesOS! This guide covers everything you need to know to use your new system.

## Getting Started

### First Boot

After installation, QuishesOS will auto-start into the Hyprland desktop environment with a beautiful liquid glass aesthetic.

**What you'll see:**
- Top bar with time, system stats, and controls
- Dock at bottom with app icons
- Liquid Pastel theme (default) with soft pink/purple gradients
- Smooth, macOS-inspired animations

### Basic Navigation

**Modifier Key:** `Super` (Windows key)

**Essential Shortcuts:**
- `Super+Return` - Open terminal (Kitty)
- `Super+E` - File manager (Thunar)
- `Super+B` - Web browser (Firefox)
- `Super+Space` - App launcher
- `Super+Q` - Close window
- `Super+F` - Toggle fullscreen
- `Super+1-9` - Switch workspaces

---

## Themes

QuishesOS includes 6 beautiful themes you can switch between instantly.

### Available Themes

1. **Liquid Pastel** (Default) - Soft pink/purple gradients, warm pastels
2. **Nordic Frost** - Cool ice blue with pale gray-blue tones
3. **Sakura Dream** - Cherry blossom pink with lavender accents
4. **Forest Mist** - Sage green with warm beige, natural aesthetic
5. **Sunset Amber** - Warm orange and golden yellow tones
6. **Aurora Glass** (Dark) - Holographic dark theme with cyan-purple gradient

### Switching Themes

Press `Super+T` to open the theme selector.

A menu will appear showing all 6 themes. Click your preferred theme, and the system will instantly update:
- Window colors and borders
- Blur intensity
- Wallpaper (if available)
- Shell components

**No restart required!**

---

## Display Settings

### Refresh Rate

Change your display refresh rate:
1. Press `Super+Shift+R`
2. Select from available rates (60Hz, 100Hz, 120Hz, etc.)
3. Rate applies immediately

### VRR (Variable Refresh Rate)

Toggle VRR/Adaptive Sync:
- Press `Super+Shift+V`
- Notification confirms new state

**Note:** VRR requires compatible display and GPU.

### Display Information

View current display settings:
- Press `Super+Shift+D`
- Shows resolution, refresh rate, and VRR status

---

## Applications

### Pre-installed Apps

**File Manager:** Thunar
- `Super+E` to launch
- Browse files, manage archives
- Network shares (gvfs)

**Terminal:** Kitty
- `Super+Return` to launch
- GPU-accelerated
- Supports ligatures

**Web Browser:** Firefox
- `Super+B` to launch
- Pre-configured for Wayland

**Text Editor:** Neovim (NovaForge)
- Launch from terminal: `nvim`
- Full C++ development environment
- See NovaForge section below

**File Archiver:** File Roller
- Open from file manager
- Supports zip, tar, 7z, rar

**System Monitor:** btop
- Launch from terminal: `btop`
- Modern, colorful system monitor

### Installing More Apps

```bash
# Search for packages
pacman -Ss package-name

# Install packages
sudo pacman -S package-name

# Remove packages
sudo pacman -R package-name
```

---

## NovaForge C++ Development

QuishesOS includes a complete C++ development environment called NovaForge.nvim.

### Quick Start

1. Open terminal: `Super+Return`
2. Create a C++ file: `nvim hello.cpp`
3. Press `F4` to insert template
4. Write your code
5. Press `F5` to build and run

### NovaForge Features

✓ **clangd LSP** - Code completion, go-to-definition, diagnostics
✓ **DAP Debugging** - Breakpoints, step through code, inspect variables
✓ **CMake Support** - Auto-detects CMake projects
✓ **Single-file Compilation** - Quick prototyping without projects
✓ **clang-tidy** - Code linting and best practices
✓ **cppcheck** - Static analysis

### Key Bindings

**Code Editing:**
- `F4` - Insert C++ template
- `F5` - Build and run
- `gd` - Go to definition
- `K` - Hover documentation
- `<leader>ca` - Code actions
- `<leader>rn` - Rename symbol

**Debugging:**
- `F9` - Toggle breakpoint
- `F10` - Step over
- `F11` - Step into
- `F12` - Step out

**Help:**
- `:NovaForgeHelp` - Show full keybinding reference

### Example Workflow

```cpp
// 1. Create file
nvim test.cpp

// 2. Press F4, then write:
#include <iostream>
#include <vector>

int main() {
    std::vector<int> numbers = {1, 2, 3, 4, 5};
    
    for (int n : numbers) {
        std::cout << n << " ";
    }
    std::cout << std::endl;
    
    return 0;
}

// 3. Press F5 to build and run
// Output: 1 2 3 4 5
```

---

## Network & Connectivity

### WiFi

1. Click network icon in top bar
2. Select your network
3. Enter password
4. Connected!

### Bluetooth

1. Open terminal
2. Run: `bluetoothctl`
3. Commands:
   - `power on` - Enable bluetooth
   - `scan on` - Scan for devices
   - `pair XX:XX:XX:XX:XX:XX` - Pair device
   - `connect XX:XX:XX:XX:XX:XX` - Connect

---

## System Settings

### Audio

Volume controls:
- `Volume Up/Down` media keys
- Or: `pactl set-sink-volume @DEFAULT_SINK@ +5%`

### Brightness

Brightness controls:
- `Brightness Up/Down` media keys
- Or: `brightnessctl set 10%+`

### Power Management

**Laptop users:**
- TLP is pre-installed for power management
- Battery optimization enabled by default

---

## Customization

### Changing Wallpaper

1. Place your wallpaper in `~/Pictures/wallpapers/`
2. Name it after a theme (e.g., `liquid_pastel.jpg`)
3. Theme switcher will use it automatically

Or use `hyprpaper`:
```bash
hyprctl hyprpaper wallpaper "eDP-1,/path/to/wallpaper.jpg"
```

### Modifying Hyprland Config

Edit `~/.config/hypr/hyprland.conf`:
```bash
nvim ~/.config/hypr/hyprland.conf
```

After changes:
```bash
hyprctl reload
```

### Adding Keybindings

Add to `hyprland.conf`:
```bash
bind = $mod, KEY, exec, command
```

Example:
```bash
bind = $mod, C, exec, gnome-calculator
```

---

## Troubleshooting

### Screen Tearing

Enable VRR:
```bash
# In hyprland.conf
misc {
    vrr = 1
}
```

### High RAM Usage

Check running processes:
```bash
htop
```

Disable unused services:
```bash
systemctl --user disable service-name
```

### WiFi Not Working

Restart NetworkManager:
```bash
sudo systemctl restart NetworkManager
```

### Audio Not Working

Check PipeWire status:
```bash
systemctl --user status pipewire
systemctl --user status wireplumber
```

Restart if needed:
```bash
systemctl --user restart pipewire wireplumber
```

---

## Tips & Tricks

### Screenshots

- `Print` - Area screenshot (to clipboard)
- `Shift+Print` - Area screenshot (save to ~/Pictures/)

### Workspace Management

- `Super+1-9` - Switch to workspace
- `Super+Shift+1-9` - Move window to workspace
- `Super+Mouse Wheel` - Scroll through workspaces

### Window Management

- `Super+Left Mouse` - Move window
- `Super+Right Mouse` - Resize window
- `Super+V` - Toggle floating
- `Super+P` - Toggle pseudo-tiling

### Performance Tips

**For Gaming:**
```bash
# Use gamemode
sudo pacman -S gamemode
# Launch games with: gamemoderun <game>
```

**For Development:**
```bash
# Increase file watchers
echo "fs.inotify.max_user_watches=524288" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p
```

---

## Updating System

```bash
# Update package database
sudo pacman -Sy

# Upgrade all packages
sudo pacman -Syu

# Clean package cache
sudo pacman -Sc
```

**Recommended:** Update weekly.

---

## Getting Help

- **NovaForge Help:** `:NovaForgeHelp` in neovim
- **Display Help:** `Super+Shift+D`
- **System Logs:** `journalctl -xe`
- **Hyprland Wiki:** https://wiki.hyprland.org

---

## Keyboard Shortcut Reference

### Core
- `Super+Return` → Terminal
- `Super+E` → File Manager
- `Super+B` → Browser
- `Super+Space` → App Launcher
- `Super+Q` → Close Window

### Themes & Display
- `Super+T` → Theme Selector
- `Super+Shift+V` → Toggle VRR
- `Super+Shift+R` → Refresh Rate Menu
- `Super+Shift+D` → Display Info

### Window Management
- `Super+F` → Fullscreen
- `Super+V` → Toggle Floating
- `Super+Left/Right/Up/Down` → Move Focus
- `Super+1-9` → Switch Workspace
- `Super+Shift+1-9` → Move to Workspace

### System
- `Super+M` → Exit Hyprland
- `Print` → Screenshot (area)

---

**Enjoy QuishesOS!**

For more information, visit the GitHub repository or check the documentation in `/usr/share/doc/quishesos/`.

**Last Updated:** 2024-06-27
