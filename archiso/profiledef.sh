#!/usr/bin/env bash
# QuishesOS archiso profile definition

iso_name="quishesos"
iso_label="QUISHESOS_$(date +%Y%m)"
iso_publisher="QuishesOS Project <https://github.com/quishesos>"
iso_application="QuishesOS Live/Installer"
iso_version="$(date +%Y.%m.%d)"
install_dir="arch"
buildmodes=('iso')
bootmodes=('uefi.grub')
arch="x86_64"
pacman_conf="pacman.conf"
airootfs_image_type="squashfs"
airootfs_image_tool_options=('-comp' 'xz' '-Xbcj' 'x86' '-b' '1M' '-Xdict-size' '1M')
file_permissions=(
  ["/etc/shadow"]="0:0:400"
  ["/root"]="0:0:750"
  ["/root/.automated_script.sh"]="0:0:755"
  ["/usr/local/bin/installer-launcher.sh"]="0:0:755"
  ["/usr/local/bin/nova-info"]="0:0:755"
  ["/usr/share/quishesos-installer/backend/install.sh"]="0:0:755"
  ["/usr/share/quishesos-installer/backend/partition.sh"]="0:0:755"
  ["/usr/share/quishesos-installer/backend/bootstrap.sh"]="0:0:755"
  ["/usr/share/quishesos-installer/backend/configure.sh"]="0:0:755"
  ["/usr/share/quishesos-installer/backend/bootloader.sh"]="0:0:755"
  ["/usr/share/quishesos-installer/launcher.sh"]="0:0:755"
)
