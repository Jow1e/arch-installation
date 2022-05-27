#!/bin/bash
set -e

username=jowie

su $username
cd ~

# AUR helper
git clone https://aur.archlinux.org/paru-bin
cd paru-bin/
makepkg -si
cd ..
rm -rf paru-bin

doas pacman -S xorg-server nitrogen rofi kitty xmonad xmonad-contrib zsh telegram-desktop ranger keepassxc
paru -S picom-git

# doas pacman -S virt-manager qemu-desktop libvirt edk2-ovmf dnsmasq iptables-nft
# doas systemctl enable --now libvirtd.service

paru -S librewolf-bin neovide

# glhf :-)
