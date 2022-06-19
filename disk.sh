#!/bin/bash
set -e


DISK="/dev/nvme0n1"

EFI_PART="${DISK}p1"
MAIN_PART="${DISK}p2"


setfont ter-132n
timedatectl set-ntp true


cfdisk --zero "${DISK}"

mkfs.fat -F32 "${EFI_PART}"
mkfs.btrfs --force --verbose "${MAIN_PART}"


mount "${CRYPT_DEV}" /mnt
btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@var
btrfs subvolume create /mnt/@snapshots

umount /mnt
mount --options noatime,ssd,compress=zstd:2,discard=async,space_cache=v2,subvol=@ "${MAIN_PART}" /mnt

mkdir --parents /mnt/{boot/efi,home,var,.snapshots}

mount --options noatime,ssd,compress=zstd:2,discard=async,space_cache=v2,subvol=@home "${MAIN_PART}" /mnt/home
mount --options noatime,ssd,compress=zstd:2,discard=async,space_cache=v2,subvol=@var "${MAIN_PART}" /mnt/var
mount --options noatime,ssd,compress=zstd:2,discard=async,space_cache=v2,subvol=@snapshots "${MAIN_PART}" /mnt/.snapshots

mount "${EFI_PART}" /mnt/boot/efi


pacstrap -i /mnt base nano
genfstab -U /mnt >> /mnt/etc/fstab
