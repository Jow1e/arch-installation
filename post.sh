#!/bin/sh
set -e


# checkout patches
sudo pacman --sync xorg-server xorg-xinit dwm-git dmenu-git st-git tabbed-git ly-git slock-git

# dunst
# ani-cli
# wireshark
# some directory stuff

# checkout how to configure it
sudo pacman --sync pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber
sudo pacman --sync ranger mpv bat tlp htop clang gcc gdb python3 python-poetry
sudo pacman --sync vimb weechat keepassxc qbittorrent moc zathura feh



sudo systemctl enable --now tlp


sudo pacman --sync rustup
rustup install stable


git clone https://aur.archlinux.org/paru-bin
cd paru-bin/
makepkg --install --syncdeps
cd ../
rm --force --recursive paru-bin


pacman --sync gstreamer gst-libav gst-plugins-base gst-plugin-pipewire


paru --sync --refresh
paru --sync trilium-bin freetube-bin tor-browser
