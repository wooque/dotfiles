ln -sf /usr/share/zoneinfo/Europe/Belgrade /etc/localtime
hwclock --systohc
nano /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" /etc/locale.conf
echo "battlestation" /etc/hostname
mkinitcpio -p linux
passwd
# pacman -S grub os-prober
# grub-install /dev/sda
# grub-mkconfig -o /boot/grub/grub.cfg
git clone https://github.com/wooque/configs.git
cd configs
git checkout i3
pacman --needed -S $(cat .packages/base)
pacman --needed -S $(cat .packages/extra)
nano /etc/sudoers
useradd -g wheel -m vuk
passwd vuk
groupadd autologin
usermod -a -G autologin vuk
cp .bootstrap/lightdm-gtk-greeter.conf /etc/lightdm/lightdm-gtk-greeter.conf
cat .bootstrap/fstab >> /etc/fstab
