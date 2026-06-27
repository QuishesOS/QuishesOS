#!/bin/bash
# Bootloader installation script
# Installs and configures systemd-boot

set -e

MOUNT_POINT="/mnt"
DISK=$1

if [ -z "$DISK" ]; then
    # Try to auto-detect disk from mount
    DISK=$(lsblk -ndo PKNAME "$(findmnt -n -o SOURCE $MOUNT_POINT)" | head -1)
    DISK="/dev/${DISK}"
fi

echo "Installing systemd-boot on $DISK..."

# Install systemd-boot
arch-chroot "$MOUNT_POINT" bootctl install

# Get root partition UUID
ROOT_UUID=$(blkid -s UUID -o value "${DISK}2")

# Create boot loader configuration
cat > "$MOUNT_POINT/boot/loader/loader.conf" <<EOF
default quishesos.conf
timeout 3
console-mode max
editor no
EOF

# Create QuishesOS boot entry
cat > "$MOUNT_POINT/boot/loader/entries/quishesos.conf" <<EOF
title   QuishesOS
linux   /vmlinuz-linux
initrd  /initramfs-linux.img
options root=UUID=${ROOT_UUID} rootflags=subvol=@ rw quiet splash loglevel=3
EOF

# Create fallback entry
cat > "$MOUNT_POINT/boot/loader/entries/quishesos-fallback.conf" <<EOF
title   QuishesOS (Fallback)
linux   /vmlinuz-linux
initrd  /initramfs-linux-fallback.img
options root=UUID=${ROOT_UUID} rootflags=subvol=@ rw
EOF

echo "Bootloader installation complete"
