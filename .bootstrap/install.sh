#!/bin/bash

sudo rm /opt/configs
sudo systemctl enable NetworkManager lightdm cronie
sudo systemctl start NetworkManager
nmtui
sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
git init
git remote add origin https://github.com/wooque/configs
git fetch --all
git reset --hard origin/i3
git checkout i3
git branch --set-upstream-to=origin/i3 i3
mkdir build
cd build
wget "https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=package-query" -O PKGBUILD
makepkg -s
sudo pacman -U --noconfirm package-query-1.9-3-x86_64.pkg.tar.xz
wget "https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=yaourt" -O PKGBUILD
makepkg -s
sudo pacman -U --noconfirm yaourt-1.9-1-any.pkg.tar.xz
cd ..
rm build
yaourt -S --noconfirm $(cat .packages/aur_base)
yes | sudo pacman -U /tmp/yaourt-tmp-vuk/freetype2-ultimate5-2.9.1-1-x86_64.pkg.tar.xz
sudo ln -sf ../conf.avail/75-emojione.conf /etc/fonts/conf.d/75-emojione.conf
yaourt -S --noconfirm $(cat .packages/aur_extra)
