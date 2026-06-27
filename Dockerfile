FROM archlinux:latest

# Update system and install required packages
RUN pacman -Syu --noconfirm && \
    pacman -S --noconfirm \
    archiso \
    base-devel \
    git \
    sudo \
    grub \
    efibootmgr \
    && pacman -Scc --noconfirm

# Create build directory
WORKDIR /build

# Copy QuishesOS files
COPY . /build/

# Make scripts executable
RUN chmod +x /build/scripts/*.sh

# Build ISO directly with mkarchiso
CMD ["/bin/bash", "-c", "mkdir -p /build/out && mkarchiso -v -w /tmp/archiso-work -o /build/out /build/archiso"]
