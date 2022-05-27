#!/bin/bash
set -e

cd /

setfont ter-132n
timedatectl set-ntp true

mkfs.vfat -F 32 /dev/nvme0n1p1
mkfs.ext4 /dev/nvme0n1p2

mount /dev/nvme0n1p2 /mnt

mkdir -p /mnt/boot/efi
mount /dev/nvme0n1p1 /mnt/boot/efi

pacstrap -i /mnt base

genfstab -U /mnt >> /mnt/etc/fstab
