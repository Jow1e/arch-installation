 GNU nano 6.3                                                       base.sh                                                                  
#!/bin/bash
set -e


USERNAME="jowie"
HOSTNAME="cloudship"
TIMEZONE="Asia/Yekaterinburg"

ln --symbolic --force "/usr/share/zoneinfo/${TIMEZONE}" /etc/localtime
hwclock --systohc --localtime

echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
echo "ru_RU.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen

echo "LANG=en_US.UTF-8" >> /etc/locale.conf
echo "FONT=ter-132n" >> /etc/vconsole.conf

echo "${HOSTNAME}" >> /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 ${HOSTNAME}.localdomain ${HOSTNAME}" >> /etc/hosts

pacman -S linux linux-headers linux-firmware base-devel btrfs-progs
pacman -S openssh git neovim man-db man-pages bat wget ranger ncdu tlp ffmpeg gimp graphicsmagick lsd btop trash-cli mpv speedtest-cli bash-c>
pacman -S networkmanager wireless_tools dialog reflector bluez bluez-utils cups
pacman -S pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber
pacman -S grub efibootmgr dosfstools mtools os-prober
pacman -S intel-ucode mesa vulkan-radeon libva-mesa-driver mesa-vdpau xf86-video-amdgpu
pacman -S terminus-font ttf-dejavu


# pacman -S hplip

# add (btrfs amdgpu) to modules
# remove (fsck) from hooks
nvim /etc/mkinitcpio.conf
mkinitcpio --preset linux

grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=grub_uefi --recheck
grub-mkconfig --output=/boot/grub/grub.cfg

systemctl enable NetworkManager
systemctl enable cups
systemctl enable bluetooth
systemctl enable tlp.service

useradd --create-home --groups users,wheel "${USERNAME}"

passwd
passwd "${USERNAME}"

# allow wheel group to execute root commands
EDITOR=nano visudo
