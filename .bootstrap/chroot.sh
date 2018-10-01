#!/bin/bash

ln -sf /usr/share/zoneinfo/Europe/Belgrade /etc/localtime
hwclock --systohc
sed -i 's/#en_US.UTF-8/en_US.UTF-8/' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "battlestation" > /etc/hostname
mkinitcpio -p linux
passwd
# pacman -S grub os-prober
# grub-install /dev/sda
# grub-mkconfig -o /boot/grub/grub.cfg
pacman --noconfirm -S $(cat .packages/base)
pacman --noconfirm -S $(cat .packages/extra)
sed -i 's/# %wheel ALL=(ALL) ALL/wheel ALL=(ALL) ALL/' /etc/sudoers
useradd -g wheel -m vuk
passwd vuk
groupadd autologin
usermod -a -G autologin vuk
cp .bootstrap/lightdm-gtk-greeter.conf /etc/lightdm/lightdm-gtk-greeter.conf
mkdir /mnt/PODACI
chown vuk:wheel /mnt/PODACI
cat .bootstrap/fstab >> /etc/fstab
