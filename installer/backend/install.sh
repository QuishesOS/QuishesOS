#!/bin/bash
# QuishesOS Installer Backend - Main Orchestrator
# Performs actual system installation from the HTML installer frontend

set -e  # Exit on error

CONFIG_FILE="/tmp/installer-config.json"
PROGRESS_FILE="/tmp/installer-progress.log"
MOUNT_POINT="/mnt"

# Initialize progress log
echo "0:Starting installation..." > "$PROGRESS_FILE"

# Read configuration from JSON written by frontend
if [ ! -f "$CONFIG_FILE" ]; then
    echo "ERROR: Configuration file not found: $CONFIG_FILE"
    exit 1
fi

# Extract config values
DISK=$(jq -r '.disk // "/dev/sda"' "$CONFIG_FILE")
USERNAME=$(jq -r '.username // "user"' "$CONFIG_FILE")
PASSWORD=$(jq -r '.password // "password"' "$CONFIG_FILE")
LANG=$(jq -r '.lang // "en_US.UTF-8"' "$CONFIG_FILE")
KEYBOARD=$(jq -r '.keyboard // "us"' "$CONFIG_FILE")
TIMEZONE=$(jq -r '.timezone // "UTC"' "$CONFIG_FILE")
INSTALL_DEVTOOLS=$(jq -r '.devtools // "true"' "$CONFIG_FILE")

echo "5:Configuration loaded" >> "$PROGRESS_FILE"

# Step 1: Partition disk
echo "10:Partitioning disk: $DISK" >> "$PROGRESS_FILE"
/usr/share/quishesos-installer/backend/partition.sh "$DISK"

# Step 2: Format and mount filesystems
echo "20:Formatting filesystems (btrfs)" >> "$PROGRESS_FILE"
mkfs.fat -F32 "${DISK}1"
mkfs.btrfs -f "${DISK}2"

mount "${DISK}2" "$MOUNT_POINT"
mkdir -p "$MOUNT_POINT/boot"
mount "${DISK}1" "$MOUNT_POINT/boot"

echo "25:Filesystems mounted" >> "$PROGRESS_FILE"

# Step 3: Bootstrap base system
echo "30:Unpacking base system (1,184 packages)" >> "$PROGRESS_FILE"
/usr/share/quishesos-installer/backend/bootstrap.sh

# Step 4: Install kernel
echo "50:Installing kernel: linux 6.9.4-quishes" >> "$PROGRESS_FILE"
arch-chroot "$MOUNT_POINT" pacman -S --noconfirm linux linux-firmware

# Step 5: Configure Hyprland
echo "60:Configuring Hyprland compositor" >> "$PROGRESS_FILE"
arch-chroot "$MOUNT_POINT" pacman -S --noconfirm hyprland

# Step 6: Generate theme assets
echo "65:Generating liquid-glass theme assets" >> "$PROGRESS_FILE"
cp -r /usr/share/quishesos-installer/themes "$MOUNT_POINT/usr/share/quishesos/"

# Step 7: Install dev tools (if requested)
if [ "$INSTALL_DEVTOOLS" = "true" ]; then
    echo "70:Installing NovaForge.nvim toolchain (clangd, gdb, lldb)" >> "$PROGRESS_FILE"
    arch-chroot "$MOUNT_POINT" pacman -S --noconfirm clang gdb lldb neovim
fi

# Step 8: Configure system
echo "80:Configuring system (locale, timezone, users)" >> "$PROGRESS_FILE"
/usr/share/quishesos-installer/backend/configure.sh "$USERNAME" "$PASSWORD" "$LANG" "$KEYBOARD" "$TIMEZONE"

# Step 9: Install bootloader
echo "90:Installing bootloader (systemd-boot)" >> "$PROGRESS_FILE"
/usr/share/quishesos-installer/backend/bootloader.sh

# Step 10: Generate fstab
echo "95:Writing fstab" >> "$PROGRESS_FILE"
genfstab -U "$MOUNT_POINT" >> "$MOUNT_POINT/etc/fstab"

# Step 11: Cleanup
echo "98:Finalizing — cleaning up live environment" >> "$PROGRESS_FILE"
sync
umount -R "$MOUNT_POINT"

# Step 12: Complete
echo "100:Installation complete." >> "$PROGRESS_FILE"
touch /tmp/installer-complete

echo "Installation finished successfully!"
exit 0
