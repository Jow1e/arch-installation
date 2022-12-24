#!/bin/sh
set -e



#===============================#
#		PREPARATION				#
#===============================#


setfont ter-132n
timedatectl set-ntp true

loadkeys us
ls /sys/firmware/efi/efivars

ping archlinux.org





#===============================#
#		VARIABLES				#
#===============================#


DISK="/dev/nvme0"
DEVICE="${DISK}n1"

DEV_ESP="${DEVICE}p1"
DEV_SWAP="${DEVICE}p2"
DEV_ROOT="${DEVICE}p3"

CRYPT_ROOT="crypt-root"
CRYPT_SWAP="crypt-swap"

ROOT_DIR="/mnt/archlinux"

BTRFS_OPTS="noatime,ssd,compress=zstd:1,discard=async,space_cache=v2"






#===============================#
#		DISK ENCRYPTION			#
#===============================#


# to erase data from disk
# need `nvme-cli` package
nvme format "${DISK}" -s 2
cfdisk --zero "${DEVICE}"

cryptsetup luksFormat --type luks1 "${DEV_ROOT}"
cryptsetup open "${DEV_ROOT}" "${CRYPT_ROOT}"

cryptsetup luksFormat --type luks1 "${DEV_SWAP}"
cryptsetup open "${DEV_SWAP}" "${CRYPT_SWAP}"







#============================#
#		FILESYSTEM			#
#============================#


mkfs.fat -F 32 "${DEV_ESP}"

mkswap "/dev/mapper/${CRYPT_SWAP}"
swapon "/dev/mapper/${CRYPT_SWAP}"

mkfs.btrfs --force --verbose "/dev/mapper/${CRYPT_ROOT}"

mkdir "${ROOT_DIR}"
mount "/dev/mapper/${CRYPT_ROOT}" "${ROOT_DIR}"
btrfs subvolume create "${ROOT_DIR}/@"
btrfs subvolume create "${ROOT_DIR}/@home"
btrfs subvolume create "${ROOT_DIR}/@snapshots"

umount "${ROOT_DIR}"
mount --options "${BTRFS_OPTS},subvol=@" "/dev/mapper/${CRYPT_ROOT}" "${ROOT_DIR}"

mkdir --parents "${ROOT_DIR}/{boot/efi,home,.snapshots}"

mount --options "${BTRFS_OPTS},subvol=@home" "/dev/mapper/${CRYPT_ROOT}" "${ROOT_DIR}/home"
mount --options "${BTRFS_OPTS},subvol=@snapshots" "/dev/mapper/${CRYPT_ROOT}" "${ROOT_DIR}/.snapshots"

mount "${DEV_ESP}" "${ROOT_DIR}/boot/efi"





#============================#
#			CHROOT			#
#============================#


pacstrap -i "${ROOT_DIR}" base nano btrfs-progs
genfstab -U "${ROOT_DIR}" >> "${ROOT_DIR}/etc/fstab"


arch-chroot "${ROOT_DIR}" /bin/bash
