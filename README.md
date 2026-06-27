# QuishesOS

**A custom Arch-based Linux distribution with macOS-inspired liquid glass desktop**

![QuishesOS](docs/banner.png)

## Overview

QuishesOS (derived from **N**guyen **V**u **A**nh → **Nova**) is a lightweight, rolling-release Linux distribution built on Arch Linux, featuring:

- 🌊 **Liquid Glass Desktop** - Frosted translucent UI with macOS-style animations
- 🎨 **6 Beautiful Themes** - From pastel liquid glass to dark Aurora Glass
- ⚡ **Hyprland Compositor** - Modern Wayland with VRR and blur effects
- 🛠️ **NovaForge.nvim** - Preconfigured Neovim for C++ development
- ⚙️ **Ultra Configurable** - Unified Settings app for everything
- 🚀 **Fast Boot** - Sub-15 second boot time, under 600MB idle RAM

## Features

### Desktop Environment
- **Hyprland** Wayland compositor with native blur and VRR support
- **macOS-style shell** with top menu bar, floating dock, and Spotlight launcher
- **System monitor sidebar** with live CPU, network, and storage stats
- **Notification center** and **Control center** for quick system settings

### Themes (6 Included)
1. **Liquid Pastel** (Default) - Soft coral/peach gradients
2. **Nordic Frost** - Ice blue minimalism
3. **Sakura Dream** - Cherry blossom pink
4. **Forest Mist** - Sage green tranquility
5. **Sunset Amber** - Warm orange glow
6. **Aurora Glass** (Dark) - Holographic iridescent with near-black windows

### Development
- **NovaForge.nvim** - Full C++ IDE experience
  - F5: Build + Run
  - F4: Insert C++ template
  - F9: Toggle breakpoint
  - Real-time diagnostics with clang-tidy/cppcheck
  - Full debugging with codelldb

### Display Management
- Native refresh rate selection
- Variable Refresh Rate (VRR/Adaptive Sync) support
- Experimental custom refresh rate profiles (75Hz, 90Hz, 100Hz, 120Hz)
- Safe testing mode with auto-revert

## System Requirements

### Minimum
- CPU: 64-bit x86 processor (Intel/AMD)
- RAM: 2GB
- Storage: 10GB
- GPU: Any GPU with Vulkan support

### Recommended
- CPU: Modern quad-core processor
- RAM: 4GB or more
- Storage: 20GB SSD
- GPU: Intel/AMD/NVIDIA with VRR support

## Installation

### Download
Download the latest ISO from [Releases](https://github.com/quishesos/QuishesOS/releases)

```bash
# Verify checksum
sha256sum -c checksums.txt
```

### Create Bootable USB
```bash
# Linux/macOS
sudo dd if=quishesOS-2026.06.27.iso of=/dev/sdX bs=4M status=progress && sync

# Windows (use Rufus or Etcher)
```

### Boot and Install
1. Boot from USB (UEFI or BIOS)
2. Select "Boot QuishesOS (x86_64, UEFI)" or "Boot QuishesOS (x86_64, BIOS)"
3. Hyprland desktop will auto-start
4. Run `sudo calamares` to install (installer to be added)

## Quick Start

### First Boot
After installation, QuishesOS boots into Hyprland with the Liquid Pastel theme.

```bash
# Open terminal
Super + Enter

# View system info
nova-info

# Open Settings app
Super + , (or click dock icon)

# Change theme
Settings → Appearance → Theme selector
```

### Keyboard Shortcuts
| Shortcut | Action |
|----------|--------|
| `Super + Enter` | Open terminal |
| `Super + Space` | Spotlight launcher |
| `Super + E` | File manager |
| `Super + ,` | Settings app |
| `Super + Shift + Q` | Close window |
| `Super + F` | Fullscreen |
| `Super + 1-9` | Switch workspace |
| `Print` | Screenshot (copy to clipboard) |
| `Shift + Print` | Screenshot (save to Pictures) |

### NovaForge C++ Development
```bash
# Open Neovim
nvim mycode.cpp

# Press F4 to insert C++ template
# Write your code
# Press F5 to build and run
# Press F9 to set breakpoint
# :NovaForgeHelp for all keybindings
```

## Building from Source

### Prerequisites
```bash
# Arch Linux host required
sudo pacman -S archiso git
```

### Build ISO
```bash
git clone https://github.com/quishesos/QuishesOS.git
cd QuishesOS
sudo ./scripts/build-iso.sh
```

The ISO will be output to `archiso/out/`.

## Project Structure

```
QuishesOS/
├── archiso/           # ISO builder profile
├── shell/             # Desktop shell components
├── themes/            # 6 color themes
├── wallpapers/        # Theme wallpapers
├── icons/             # Custom icon set
├── quishesOS-settings/# Unified Settings app
├── NovaForge.nvim/    # Neovim distribution
└── scripts/           # Build utilities
```

## Documentation

- [User Guide](docs/user-guide.md)
- [Theme Customization](docs/themes.md)
- [NovaForge.nvim Guide](docs/novaforge.md)
- [Developer Guide](docs/development.md)

## Contributing

Contributions welcome! Please read [CONTRIBUTING.md](CONTRIBUTING.md) first.

## License

QuishesOS is licensed under the MIT License. See [LICENSE](LICENSE) for details.

## Credits

- Based on [Arch Linux](https://archlinux.org/)
- [Hyprland](https://hyprland.org/) compositor
- Inspired by macOS design language

---

**QuishesOS** - Liquid glass. Infinite possibilities.
