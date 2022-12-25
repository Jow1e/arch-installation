#!/bin/sh
set -e


# /etc/iwd/main.conf
sudo systemctl enable --now systemd-resolved 
sudo ln -srf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
sudo systemctl restart iwd


# checkout patches
# /etc/X11/xorg.conf.d/20-intel.conf
sudo pacman --sync libx11 xorg-server libxrandr xorg-xrandr xorg-xinit libxft xorg-xrdb xorg-xclipboard


# checkout how to configure it
sudo pacman --sync pipewire pipewire-alsa pipewire-jack pipewire-pulse wireplumber
sudo pacman --sync ranger bat tlp htop clang gcc gdb python3 python-poetry zsh
sudo pacman --sync weechat keepassxc qbittorrent moc zathura feh dunst wireshark-qt nyxt mpv wireguard-tools texlive-most texlive-most


sudo pacman --sync rustup
rustup install stable


git clone https://aur.archlinux.org/paru-bin
cd paru-bin/
makepkg --install --syncdeps
cd ../
rm --force --recursive paru-bin


sudo pacman --sync gstreamer gst-libav gst-plugins-base gst-plugin-pipewire gst-plugins-good


paru --sync trilium-bin freetube-bin ani-cli librewolf-bin
paru --sync dwm dmenu st tabbed-git ly slock intel-hybrid-codec-driver

sudo systemctl enable tlp
sudo systemctl enable ly
