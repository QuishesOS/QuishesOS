# QuishesOS Build Guide

This guide covers building the QuishesOS ISO from source.

## Prerequisites

### System Requirements

- **Operating System:** Arch Linux (or Arch-based distro)
- **Disk Space:** 50GB+ free
- **RAM:** 8GB+ recommended
- **Network:** Internet connection for package downloads

### Required Packages

```bash
sudo pacman -S archiso git base-devel
```

---

## Quick Start

```bash
# Clone repository
git clone https://github.com/yourusername/QuishesOS.git
cd QuishesOS/

# Validate configuration
sudo ./scripts/validate-config.sh

# Build ISO
sudo ./scripts/build-iso.sh
```

The ISO will be created in `out/quishesos-YYYY.MM.DD-x86_64.iso`.

---

## Detailed Build Process

### 1. Verify archiso Profile

Check that all required files exist:

```bash
ls archiso/
# Expected: packages.x86_64, profiledef.sh, airootfs/, grub/, etc.
```

### 2. Validate Configuration

Run pre-build validation:

```bash
sudo ./scripts/validate-config.sh
```

This checks for:
- Missing configuration files
- Script executable permissions
- Theme file presence
- NovaForge.nvim setup

Fix any errors before proceeding.

### 3. Build the ISO

```bash
sudo ./scripts/build-iso.sh
```

**What happens:**
1. Validates archiso profile
2. Creates work directory `/tmp/archiso-work`
3. Downloads packages (~2GB)
4. Builds squashfs filesystem
5. Creates bootable ISO image
6. Generates SHA256 checksum

**Build time:** 10-30 minutes depending on system.

### 4. Verify Build

```bash
cd out/
sha256sum -c quishesos-*.iso.sha256
```

Expected: `quishesos-*.iso: OK`

---

## Customization

### Adding Packages

Edit `archiso/packages.x86_64`:

```bash
vim archiso/packages.x86_64
# Add package names, one per line
```

Rebuild ISO after changes.

### Modifying Themes

Theme configs are in `themes/`:

```bash
vim themes/liquid_pastel.conf
# Edit colors (RGB values)
```

### Changing Wallpapers

Place wallpapers in `archiso/airootfs/etc/skel/Pictures/wallpapers/`:

```bash
cp my-wallpaper.jpg archiso/airootfs/etc/skel/Pictures/wallpapers/liquid_pastel.jpg
```

Name format: `{theme_name}.jpg`

### Modifying Hyprland Config

Edit base config:

```bash
vim archiso/airootfs/etc/skel/.config/hypr/hyprland.conf
```

Changes apply to all new users.

---

## Testing the ISO

### QEMU (VM Testing)

```bash
# Create test disk
qemu-img create -f qcow2 test-disk.qcow2 30G

# Boot ISO
qemu-system-x86_64 \
  -enable-kvm \
  -m 4G \
  -cpu host \
  -smp 4 \
  -boot d \
  -cdrom out/quishesos-*.iso \
  -drive file=test-disk.qcow2,format=qcow2,if=virtio
```

### Writing to USB

```bash
# Find USB device
lsblk

# Write ISO (replace /dev/sdX)
sudo dd if=out/quishesos-*.iso of=/dev/sdX bs=4M status=progress && sync
```

**Warning:** This will erase the USB drive!

### Bare Metal Testing

1. Write ISO to USB
2. Boot from USB
3. Test installation on real hardware

---

## Directory Structure

```
QuishesOS/
├── archiso/              # archiso profile
│   ├── packages.x86_64   # Package list
│   ├── profiledef.sh     # ISO metadata
│   ├── airootfs/         # Root filesystem overlay
│   │   └── etc/skel/     # User home skeleton
│   │       ├── .config/  # User configs
│   │       └── Pictures/ # Wallpapers
│   └── grub/             # Boot loader config
├── themes/               # Hyprland theme configs
├── icons/                # Custom SVG icons
├── docs/                 # Documentation
├── scripts/              # Build and utility scripts
│   ├── build-iso.sh      # Main build script
│   └── validate-config.sh # Pre-build checks
└── out/                  # Build output (ISOs)
```

---

## Troubleshooting

### Build Fails: "Package not found"

**Cause:** Package name typo or unavailable in repos

**Fix:**
```bash
# Check package exists
pacman -Ss package-name

# Remove or fix in packages.x86_64
vim archiso/packages.x86_64
```

### Build Fails: "Permission denied"

**Cause:** Not running as root

**Fix:**
```bash
sudo ./scripts/build-iso.sh
```

### ISO Won't Boot

**Causes:**
- Corrupt download
- Bad USB write
- BIOS/UEFI settings

**Fixes:**
- Verify checksum: `sha256sum -c *.sha256`
- Rewrite USB with `dd`
- Enable UEFI boot in BIOS
- Disable Secure Boot

### Missing Packages in Live Environment

**Cause:** Package not in `packages.x86_64`

**Fix:**
```bash
# Add to package list
echo "missing-package" >> archiso/packages.x86_64

# Rebuild ISO
sudo ./scripts/build-iso.sh
```

---

## Advanced Topics

### Custom Kernel

To use a custom kernel:

1. Edit `archiso/packages.x86_64`
2. Replace `linux` with `linux-zen` or `linux-lts`
3. Rebuild

### AUR Packages

archiso doesn't support AUR directly. Options:

1. **Build package locally:**
```bash
# Build AUR package
git clone https://aur.archlinux.org/package.git
cd package/
makepkg -si

# Copy to local repo
sudo mkdir -p /var/cache/pacman/pkg/
sudo cp *.pkg.tar.zst /var/cache/pacman/pkg/
```

2. **Include in airootfs:**
```bash
# Install package files directly
cp -r package-files/ archiso/airootfs/usr/
```

### Changing ISO Name

Edit `archiso/profiledef.sh`:

```bash
iso_name="quishesos"
iso_label="QUISHESOS"
```

---

## CI/CD Integration

For automated builds:

```yaml
# GitHub Actions example
- name: Build ISO
  run: |
    sudo pacman -Syu --noconfirm archiso
    sudo ./scripts/build-iso.sh
    
- name: Upload ISO
  uses: actions/upload-artifact@v3
  with:
    name: quishesos-iso
    path: out/*.iso
```

---

## Performance Tips

- Use SSD for build directory
- Enable parallel downloads in `/etc/pacman.conf`:
  ```
  ParallelDownloads = 5
  ```
- Keep `/tmp` on tmpfs for faster builds

---

**Build Requirements Summary:**
- Arch Linux host system
- archiso package installed
- Root/sudo access
- 50GB+ free space
- Internet connection

**Questions?** Open an issue on GitHub.

**Last Updated:** 2024-06-27
