#!/bin/sh
set -e


CRYPTROOT_FILE="/root/crypt-root.keyfile"
CRYPTSWAP_FILE="/root/crypt-swap.keyfile"


USERNAME="jow1e"
HOSTNAME="thinkpad"
TIMEZONE="Europe/Moscow"


ln --symbolic --force "/usr/share/zoneinfo/${TIMEZONE}" /etc/localtime
hwclock --systohc --utc


echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
echo "ru_RU.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf


echo "${HOSTNAME}" >> /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 ${HOSTNAME}.localdomain ${HOSTNAME}" >> /etc/hosts


pacman --sync linux linux-firmware linux-headers base-devel
pacman --sync iwd wget reflector bluez bluez-utils
pacman --sync openssh git neovim tree
pacman --sync intel-ucode xf86-video-intel mesa vulkan-intel intel-media-driver
pacman --sync grub efibootmgr


systemctl enable iwd
systemctl enable bluetooth


dd bs=512 count=4 if=/dev/random of="${CRYPTROOT_FILE}" iflag=fullblock
chmod 600 "${CRYPTROOT_FILE}"
cryptsetup luksAddKey /dev/nvme0n1p3 "${CRYPTROOT_FILE}"

dd bs=512 count=4 if=/dev/random of="${CRYPTSWAP_FILE}" iflag=fullblock
chmod 600 "${CRYPTSWAP_FILE}"
cryptsetup luksAddKey /dev/nvme0n1p2 "${CRYPTSWAP_FILE}"


# FILES=(/root/crypt-root.keyfile /root/crypt-swap.keyfile)
# HOOKS=(... block encrypt openswap resume filesystems ...)
#
# /etc/initcpio/hooks/openswap
# /etc/initcpio/install/openswap
nvim /etc/mkinitcpio.conf
mkinitcpio --preset linux



grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=core --recheck
grub-mkconfig --output=/boot/grub/grub.cfg


useradd --create-home --groups users,wheel,audio,video,power,network,log,storage,uucp "${USERNAME}"


passwd
passwd "${USERNAME}"


echo "%wheel ALL=(ALL:ALL) ALL" >> /etc/sudoers
