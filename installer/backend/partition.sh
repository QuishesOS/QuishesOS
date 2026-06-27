#!/bin/bash
# Disk partitioning script for QuishesOS installer
# Creates ESP (512MB) + btrfs root partition

set -e

DISK=$1

if [ -z "$DISK" ]; then
    echo "ERROR: No disk specified"
    exit 1
fi

echo "Partitioning $DISK with GPT layout..."

# Wipe existing partition table
sgdisk --zap-all "$DISK"

# Create GPT partition table
sgdisk --clear \
    --new=1:0:+512M --typecode=1:ef00 --change-name=1:"EFI System" \
    --new=2:0:0 --typecode=2:8300 --change-name=2:"QuishesOS Root" \
    "$DISK"

# Inform kernel of partition changes
partprobe "$DISK"
sleep 2

echo "Partitioning complete: ${DISK}1 (ESP 512MB), ${DISK}2 (root)"
