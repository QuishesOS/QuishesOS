#!/bin/bash
# Bootstrap base system with pacstrap
# Installs minimal Arch base + QuishesOS essentials

set -e

MOUNT_POINT="/mnt"

echo "Bootstrapping base system to $MOUNT_POINT..."

# Install base system + essentials
pacstrap "$MOUNT_POINT" \
    base \
    base-devel \
    linux \
    linux-firmware \
    btrfs-progs \
    networkmanager \
    sudo \
    nano \
    vim \
    git \
    wget \
    curl \
    htop \
    man-db \
    man-pages

# Copy QuishesOS shell and configs
cp -r /usr/share/quishesos/* "$MOUNT_POINT/usr/share/quishesos/" 2>/dev/null || true
cp -r /etc/skel/.config "$MOUNT_POINT/etc/skel/" 2>/dev/null || true

echo "Base system bootstrap complete"
