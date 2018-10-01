#!/bin/bash

timedatectl set-ntp true
mkfs.ext4 /dev/sda3
mount /dev/sda3 /mnt
pacstrap /mnt base base base-devel
genfstab -U /mnt >> /mnt/etc/fstab
sed -i 's/rw,relatime/rw,noatime/' /mnt/etc/fstab
cp -r configs /mnt/opt/configs
arch-chroot /mnt
