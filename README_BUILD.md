# QuishesOS ISO Build Guide

## ⚡ Fastest Method: GitHub Actions (Recommended)

Build your ISO automatically in the cloud - no local setup required!

### Steps:

1. **Initialize Git repository** (if not already):
   ```bash
   git init
   git add .
   git commit -m "Initial QuishesOS commit"
   ```

2. **Push to GitHub**:
   ```bash
   # Create a new repository on GitHub first, then:
   git remote add origin https://github.com/YOUR_USERNAME/QuishesOS.git
   git branch -M main
   git push -u origin main
   ```

3. **Automatic ISO Build**:
   - GitHub Actions will automatically start building
   - Go to: `https://github.com/YOUR_USERNAME/QuishesOS/actions`
   - Wait ~15-20 minutes for build to complete

4. **Download ISO**:
   - Click on the completed workflow run
   - Scroll to "Artifacts" section
   - Download `quishesos-iso`
   - Extract the ZIP to get your ISO file

### Manual Trigger

You can also manually trigger a build:
1. Go to Actions tab on GitHub
2. Click "Build QuishesOS ISO" workflow
3. Click "Run workflow"
4. Select branch and click "Run workflow"

---

## 🐧 Linux Method (If you have Linux)

```bash
# On Arch Linux or Arch-based system:
sudo pacman -S archiso
cd QuishesOS
sudo ./scripts/build-iso.sh

# Output: out/quishesos-YYYY.MM.DD-x86_64.iso
```

---

## 📦 What Gets Built

- **ISO File**: Bootable QuishesOS installation media
- **Size**: ~2-3 GB (depends on packages)
- **Boot Modes**: BIOS (syslinux)
- **Checksum**: SHA256 for verification

---

## 🚀 After Building

1. **Test in VM**:
   - VirtualBox: Create new VM, attach ISO
   - VMware: Create new VM, use ISO
   - QEMU: `qemu-system-x86_64 -enable-kvm -m 4G -boot d -cdrom quishesos.iso`

2. **Write to USB** (Windows):
   - Use [Rufus](https://rufus.ie/)
   - Or [Balena Etcher](https://www.balena.io/etcher/)

3. **Write to USB** (Linux):
   ```bash
   sudo dd if=quishesos.iso of=/dev/sdX bs=4M status=progress && sync
   # Replace /dev/sdX with your USB device
   ```

---

## ⚠️ Troubleshooting

**GitHub Actions fails?**
- Check workflow logs for errors
- Ensure archiso profile is valid
- Verify packages.x86_64 has correct packages

**ISO won't boot?**
- Verify ISO checksum (SHA256)
- Try different USB writing tool
- Check BIOS boot order

**Need help?**
- Check logs in workflow runs
- Review archiso documentation
- Test build on actual Arch Linux

---

## 📊 Build Times

- **GitHub Actions**: ~15-20 minutes
- **Local Arch Linux**: ~10-30 minutes (depends on system)
- **WSL2**: ~20-40 minutes (if configured properly)
- **Docker**: ~20-40 minutes (if configured properly)
