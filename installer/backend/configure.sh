#!/bin/bash
# System configuration script
# Configures locale, timezone, hostname, users, and sudoers

set -e

USERNAME=$1
PASSWORD=$2
LANG=$3
KEYBOARD=$4
TIMEZONE=$5
MOUNT_POINT="/mnt"

if [ -z "$USERNAME" ] || [ -z "$PASSWORD" ]; then
    echo "ERROR: Username and password are required"
    exit 1
fi

echo "Configuring system for user: $USERNAME"

# Set locale
echo "en_US.UTF-8 UTF-8" >> "$MOUNT_POINT/etc/locale.gen"
echo "${LANG} UTF-8" >> "$MOUNT_POINT/etc/locale.gen"
arch-chroot "$MOUNT_POINT" locale-gen
echo "LANG=${LANG}" > "$MOUNT_POINT/etc/locale.conf"

# Set keyboard layout
echo "KEYMAP=${KEYBOARD}" > "$MOUNT_POINT/etc/vconsole.conf"

# Set timezone
arch-chroot "$MOUNT_POINT" ln -sf "/usr/share/zoneinfo/${TIMEZONE}" /etc/localtime
arch-chroot "$MOUNT_POINT" hwclock --systohc

# Set hostname
echo "quishesos" > "$MOUNT_POINT/etc/hostname"
cat > "$MOUNT_POINT/etc/hosts" <<EOF
127.0.0.1   localhost
::1         localhost
127.0.1.1   quishesos.localdomain quishesos
EOF

# Create user
arch-chroot "$MOUNT_POINT" useradd -m -G wheel,audio,video,storage -s /bin/bash "$USERNAME"
echo "${USERNAME}:${PASSWORD}" | arch-chroot "$MOUNT_POINT" chpasswd

# Enable sudo for wheel group
echo "%wheel ALL=(ALL:ALL) ALL" >> "$MOUNT_POINT/etc/sudoers.d/wheel"
chmod 0440 "$MOUNT_POINT/etc/sudoers.d/wheel"

# Enable NetworkManager
arch-chroot "$MOUNT_POINT" systemctl enable NetworkManager

# Copy QuishesOS configs to user home
cp -r "$MOUNT_POINT/etc/skel/.config" "$MOUNT_POINT/home/${USERNAME}/"
arch-chroot "$MOUNT_POINT" chown -R "${USERNAME}:${USERNAME}" "/home/${USERNAME}"

echo "System configuration complete"
