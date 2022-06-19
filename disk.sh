#!/bin/bash
set -e


#paru -S tlpui

paru -S ttf-ms-fonts

sudo pacman -S rustup
rustup install stable

git clone https://aur.archlinux.org/paru-bin
cd paru-bin/
makepkg --install --syncdeps
cd ../
rm --force --recursive paru-bin

sudo pacman -S telegram-desktop keepassxc qbittorrent chromium libreoffice firefox
sudo pacman -S gnome gnome-tweaks
paru -S picom-git trilium-bin
pacman -S qutebrowser
paru -S ascii-image-converter cpufetch jitsi-meet-desktop stacer moc


sudo systemctl enable gdm
