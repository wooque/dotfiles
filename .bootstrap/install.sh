#!/bin/bash

ln -sf /usr/share/zoneinfo/Europe/Belgrade /etc/localtime
hwclock --systohc

sed -i 's/#en_US.UTF-8/en_US.UTF-8/' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

echo "battlestation" > /etc/hostname
mkinitcpio -p linux
echo "Enter password for root"
passwd

pacman -S --noconfirm grub os-prober
grub-install /dev/sda
sed -i 's/GRUB_TIMEOUT=5/GRUB_TIMEOUT=0/' /etc/default/grub
sed -i 's/GRUB_CMDLINE_LINUX=""/GRUB_CMDLINE_LINUX="elevator=deadline"/' /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg

cd /opt/configs
pacman --noconfirm -S $(cat .bootstrap/packages/base)
pacman --noconfirm -S $(cat .bootstrap/packages/extra)

sed -i 's/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /etc/sudoers
useradd -g wheel -m vuk
echo "Enter password for vuk"
passwd vuk
groupadd autologin
usermod -a -G autologin vuk
# if virtualbox and docker from extra are installed
usermod -a -G vboxusers vuk
usermod -a -G docker vuk

cp .bootstrap/lightdm-gtk-greeter.conf /etc/lightdm/lightdm-gtk-greeter.conf
sed -i 's/#autologin-user=/autologin-user=vuk/' /etc/lightdm/lightdm.conf
ln -sf /usr/lib/systemd/system/lightdm.service /etc/systemd/system/display-manager.service

cp .bootstrap/backup.sh /usr/local/bin/backup.sh
ln -sf /usr/lib/systemd/system/cronie.service /etc/systemd/system/multi-user.target.wants/cronie.service

#systemctl enable NetworkManager
ln -sf /usr/lib/systemd/system/NetworkManager.service /etc/systemd/system/dbus-org.freedesktop.NetworkManager.service
ln -sf /usr/lib/systemd/system/NetworkManager.service /etc/systemd/system/multi-user.target.wants/NetworkManager.service
ln -sf /usr/lib/systemd/system/NetworkManager-dispatcher.service /etc/systemd/system/dbus-org.freedesktop.nm-dispatcher.service
mkdir /etc/systemd/system/network-online.target.wants
ln -sf /usr/lib/systemd/system/NetworkManager-wait-online.service /etc/systemd/system/network-online.target.wants/NetworkManager-wait-online.service

mkdir /etc/systemd/system/timers.target.wants
ln -sf /usr/lib/systemd/system/fstrim.timer /etc/systemd/system/timers.target.wants/fstrim.timer

mkdir /mnt/PODACI
chown vuk:wheel /mnt/PODACI
cat .bootstrap/fstab >> /etc/fstab

cd /opt
mkdir build
chown vuk:wheel build
cd build
wget "https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=package-query" -O PKGBUILD
sudo -u vuk makepkg -s
pacman -U --noconfirm $(find . -name "package-query*.pkg.tar.xz")
wget "https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=yaourt" -O PKGBUILD
sudo -u vuk makepkg -s
pacman -U --noconfirm $(find . -name "yaourt*.pkg.tar.xz")
cd /opt
rm -rf /opt/build

cd /opt/configs
sudo -u vuk yaourt -S --noconfirm $(cat .bootstrap/packages/aur_base)
yes | pacman -U $(find /tmp/yaourt-tmp-vuk -name "freetype2-ultimate5*.pkg.tar.xz")
ln -sf ../conf.avail/75-emojione.conf /etc/fonts/conf.d/75-emojione.conf
# for ncurses needed for VMWare player
sudo -u vuk gpg --recv-key 702353E0F7E48EDB
sudo -u vuk yaourt -S --noconfirm $(cat .bootstrap/packages/aur_extra)
cd /opt
rm -rf /opt/configs

cd /home/vuk
sudo -u vuk sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"

sudo -u vuk git init
sudo -u vuk git remote add origin https://github.com/wooque/configs 
sudo -u vuk git fetch --all
sudo -u vuk git reset --hard origin/i3
sudo -u vuk git checkout i3

echo "----------------------------------------------"
echo "SETUP crontab:"
echo "sudo cp .bootstrap/crontab /var/spool/cron/vuk"
echo "DONT FORGET TO SETUP .ssh/pass!!!"

