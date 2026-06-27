#!/bin/bash
# QuishesOS ISO Build Script (Enhanced)
# Builds bootable ISO using archiso

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== QuishesOS ISO Builder ===${NC}"
echo ""

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}Error: This script must be run as root${NC}"
    echo "Usage: sudo $0"
    exit 1
fi

# Check if archiso is installed
if ! command -v mkarchiso &> /dev/null; then
    echo -e "${RED}Error: archiso is not installed${NC}"
    echo "Install with: sudo pacman -S archiso"
    exit 1
fi

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
ARCHISO_DIR="$PROJECT_ROOT/archiso"
OUT_DIR="$PROJECT_ROOT/out"
WORK_DIR="/tmp/archiso-work"

echo "Project root: $PROJECT_ROOT"
echo "Archiso profile: $ARCHISO_DIR"
echo "Output directory: $OUT_DIR"
echo ""

# Validate archiso profile
echo -e "${YELLOW}Validating archiso profile...${NC}"

if [ ! -f "$ARCHISO_DIR/packages.x86_64" ]; then
    echo -e "${RED}Error: packages.x86_64 not found${NC}"
    exit 1
fi

if [ ! -f "$ARCHISO_DIR/profiledef.sh" ]; then
    echo -e "${RED}Error: profiledef.sh not found${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Profile validation passed${NC}"
echo ""

# Create output directory
mkdir -p "$OUT_DIR"

# Clean previous work directory
if [ -d "$WORK_DIR" ]; then
    echo -e "${YELLOW}Cleaning previous work directory...${NC}"
    rm -rf "$WORK_DIR"
fi

# Start timer
start_time=$(date +%s)

# Build ISO
echo -e "${GREEN}Building ISO...${NC}"
echo "This may take 10-30 minutes depending on your system."
echo ""

if mkarchiso -v -w "$WORK_DIR" -o "$OUT_DIR" "$ARCHISO_DIR"; then
    # Build successful
    end_time=$(date +%s)
    duration=$((end_time - start_time))
    minutes=$((duration / 60))
    seconds=$((duration % 60))

    echo ""
    echo -e "${GREEN}=== Build Successful! ===${NC}"
    echo ""

    # Find the generated ISO
    iso_file=$(find "$OUT_DIR" -name "*.iso" -type f -printf '%T@ %p\n' | sort -n | tail -1 | cut -d' ' -f2-)

    if [ -n "$iso_file" ]; then
        iso_size=$(du -h "$iso_file" | cut -f1)
        iso_name=$(basename "$iso_file")

        echo "ISO file: $iso_name"
        echo "Location: $iso_file"
        echo "Size: $iso_size"
        echo "Build time: ${minutes}m ${seconds}s"
        echo ""

        # Generate checksums
        echo -e "${YELLOW}Generating checksums...${NC}"
        cd "$OUT_DIR"
        sha256sum "$iso_name" > "${iso_name}.sha256"
        echo -e "${GREEN}✓ SHA256: ${iso_name}.sha256${NC}"
        echo ""

        # Display next steps
        echo -e "${GREEN}=== Next Steps ===${NC}"
        echo "1. Test in VM:"
        echo "   qemu-system-x86_64 -enable-kvm -m 4G -boot d -cdrom \"$iso_file\""
        echo ""
        echo "2. Write to USB (replace /dev/sdX with your USB device):"
        echo "   sudo dd if=\"$iso_file\" of=/dev/sdX bs=4M status=progress && sync"
        echo ""
        echo "3. Verify checksum:"
        echo "   sha256sum -c \"${iso_name}.sha256\""
    else
        echo -e "${YELLOW}Warning: ISO file not found in output directory${NC}"
    fi
else
    echo -e "${RED}Build failed!${NC}"
    exit 1
fi

# Clean work directory (optional)
echo ""
read -p "Clean work directory? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    rm -rf "$WORK_DIR"
    echo -e "${GREEN}✓ Work directory cleaned${NC}"
fi

exit 0
