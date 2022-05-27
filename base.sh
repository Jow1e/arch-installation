#!/bin/bash
set -e

username=jowie
hostname=cloudship

cd /

ln -s /usr/share/zoneinfo/Asia/Yekaterinburg /etc/localtime
hwclock --systohc --localtime

echo "en_US.UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
echo "FONT=ter-132n" >> /etc/vconsole.conf

echo "$hostname" >> /etc/hostname
echo "127.0.0.1	localhost" >> /etc/hosts
echo "::1	localhost" >> /etc/hosts
echo "127.0.1.1	$hostname" >> /etc/hosts

pacman -S linux linux-headers linux-firmware
pacman -S base-devel opendoas git terminus-font nano neovim htop man locate
pacman -S networkmanager network-manager-applet dialog openssh reflector
pacman -S pulseaudio pulseaudio-alsa pulseaudio-jack pavucontrol
pacman -S grub efibootmgr
pacman -S intel-ucode mesa vulkan-radeon libva-mesa-driver mesa-vdpau xf86-video-amdgpu

nano /etc/mkinitcpio.conf
mkinitcpio -p linux

grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=grub_uefi
grub-mkconfig -o /boot/grub/grub.cfg

systemctl enable NetworkManager

useradd -m -g users $username

pacman -Rns --noconfirm sudo
ln -s /usr/bin/doas /usr/bin/sudo
echo "permit persist $username as root" >> /etc/doas.conf

passwd
passwd $username
