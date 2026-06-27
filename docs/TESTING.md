# QuishesOS Testing Guide

This document provides comprehensive testing procedures for QuishesOS.

## Prerequisites

- Linux system with KVM support (for VM testing)
- QEMU installed
- 8GB+ RAM recommended
- 50GB+ free disk space

## Test Categories

### 1. ISO Build Verification

**Objective:** Ensure ISO builds successfully without errors.

**Steps:**
```bash
cd QuishesOS/
sudo ./scripts/validate-config.sh  # Pre-build validation
sudo ./scripts/build-iso.sh        # Build ISO
```

**Expected Results:**
- ✓ No validation errors
- ✓ ISO file created in `out/` directory
- ✓ ISO size: 2-3 GB
- ✓ SHA256 checksum generated
- ✓ Build completes in 10-30 minutes

**Pass Criteria:** ISO builds without errors, checksum valid.

---

### 2. Boot Testing (QEMU)

**Objective:** Verify ISO boots and loads installer correctly.

**Steps:**
```bash
qemu-system-x86_64 \
  -enable-kvm \
  -m 4G \
  -cpu host \
  -smp 4 \
  -boot d \
  -cdrom out/quishesos-*.iso \
  -drive file=test-disk.qcow2,format=qcow2,if=virtio
```

**Expected Results:**
- ✓ GRUB menu appears within 5 seconds
- ✓ QuishesOS option is default
- ✓ System boots to Firefox installer
- ✓ Installer UI loads with liquid glass aesthetic
- ✓ No kernel panics or errors

**Pass Criteria:** System boots to installer without errors.

---

### 3. Installer Flow Testing

**Objective:** Complete full installation process.

**Steps:**
1. Boot ISO in QEMU
2. Click through installer steps:
   - Welcome screen
   - Keyboard/Region selection
   - Disk partitioning
   - User account creation
   - Installation progress
   - Finish screen
3. Reboot after installation

**Expected Results:**
- ✓ All 6 steps accessible
- ✓ Disk detection works
- ✓ Installation completes successfully
- ✓ No errors during package installation
- ✓ Reboot prompt appears

**Pass Criteria:** Installation completes, system reboots successfully.

---

### 4. Desktop Shell Testing

**Objective:** Verify Hyprland and eww shell load correctly.

**Steps:**
1. Boot installed system
2. Login with created user credentials
3. Observe desktop environment

**Expected Results:**
- ✓ Auto-login works (or TTY login prompt)
- ✓ Hyprland starts automatically
- ✓ Top bar (eww) visible with time, system stats
- ✓ Dock visible at bottom with app icons
- ✓ Wallpaper loads (default: Liquid Pastel theme)
- ✓ No visual glitches or artifacts

**Pass Criteria:** Desktop shell fully functional, all components visible.

---

### 5. Theme Switching Testing

**Objective:** Test all 6 themes switch correctly.

**Steps:**
1. Press `Super+T` to open theme selector
2. Select each theme:
   - Liquid Pastel
   - Nordic Frost
   - Sakura Dream
   - Forest Mist
   - Sunset Amber
   - Aurora Glass
3. Observe theme changes

**Expected Results:**
- ✓ Rofi menu shows all 6 themes
- ✓ Theme applies immediately on selection
- ✓ Window borders update to theme colors
- ✓ Blur effect matches theme intensity
- ✓ Wallpaper changes (if available)
- ✓ No lag or visual glitches

**Pass Criteria:** All themes functional, seamless switching.

---

### 6. Display/VRR Testing

**Objective:** Test display management features.

**Steps:**
1. Press `Super+Shift+D` for display info
2. Press `Super+Shift+V` to toggle VRR
3. Press `Super+Shift+R` to change refresh rate

**Expected Results:**
- ✓ Display info shows current resolution and refresh rate
- ✓ VRR toggle works (if supported by display)
- ✓ Refresh rate menu shows available rates
- ✓ Refresh rate changes take effect
- ✓ Notifications confirm changes

**Pass Criteria:** Display management works, no crashes.

---

### 7. NovaForge C++ Workflow Testing

**Objective:** Test complete C++ development workflow.

**Steps:**
1. Open terminal: `Super+Return`
2. Launch neovim: `nvim test.cpp`
3. Press `F4` to insert C++ template
4. Write simple program:
```cpp
#include <iostream>

int main() {
    std::cout << "Hello, QuishesOS!" << std::endl;
    return 0;
}
```
5. Press `F5` to build and run
6. Test debugging:
   - Press `F9` to set breakpoint
   - Run with debugger
   - Press `F10` to step over

**Expected Results:**
- ✓ Neovim loads with NovaForge config
- ✓ F4 inserts template correctly
- ✓ LSP provides code completion
- ✓ F5 compiles and runs program
- ✓ Output: "Hello, QuishesOS!"
- ✓ Debugging works (breakpoints, stepping)

**Pass Criteria:** Full C++ workflow functional end-to-end.

---

### 8. Application Launch Testing

**Objective:** Verify all pre-installed applications launch.

**Steps:**
Test each application:
- `Super+Return` → Kitty terminal
- `Super+E` → Thunar file manager
- `Super+B` → Firefox browser
- `Super+Space` → App launcher (rofi)
- Click dock icons

**Expected Results:**
- ✓ All apps launch within 2 seconds
- ✓ Apps use correct theme/opacity
- ✓ No crashes or errors
- ✓ Apps appear in window list

**Pass Criteria:** All apps launch successfully.

---

### 9. Network Configuration Testing

**Objective:** Test network connectivity.

**Steps:**
1. Click network icon in top bar
2. Select WiFi network
3. Enter password
4. Test connectivity: `ping google.com`

**Expected Results:**
- ✓ NetworkManager applet works
- ✓ WiFi networks detected
- ✓ Connection successful
- ✓ Internet access works
- ✓ DNS resolution works

**Pass Criteria:** Network connectivity functional.

---

### 10. Performance Testing

**Objective:** Measure boot time and RAM usage.

**Steps:**
```bash
# Boot time (from GRUB to desktop)
# Time manually or check journal:
systemd-analyze

# RAM usage at idle
free -h
htop
```

**Expected Results:**
- ✓ Boot time: <10 seconds (GRUB to desktop)
- ✓ Idle RAM: <800 MB
- ✓ Smooth desktop performance
- ✓ No lag in animations

**Pass Criteria:** Performance meets targets.

---

## Regression Testing

After any code changes, run these quick checks:

1. **Build test:** `sudo ./scripts/build-iso.sh`
2. **Boot test:** QEMU boot to installer
3. **Theme test:** Switch between 2 themes
4. **App test:** Launch terminal and Firefox

---

## Known Issues

Document any known issues here during testing:

- [None currently documented]

---

## Test Environment Specs

Recommended test hardware:
- CPU: 4+ cores, KVM support
- RAM: 8GB+
- Storage: 50GB+ SSD
- Display: 1920x1080+

---

## Reporting Issues

When reporting issues, include:
1. ISO version/build date
2. Hardware specs (CPU, RAM, GPU)
3. Steps to reproduce
4. Expected vs actual behavior
5. Logs from `/var/log/` if applicable

---

**Last Updated:** 2024-06-27
