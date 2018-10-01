#!/bin/bash

pacman -Qeq > /mnt/PODACI/packages.txt
rsync -azP -e "ssh -p 21299" --exclude='*.iso' --exclude='*.vdi' --exclude='*.vmdk' /mnt/PODACI root@51.15.75.156:/root/backup --delete 
cd /home/vuk && zip -er -P $(cat .ssh/pass) ssh.zip .ssh
rsync -azP -e "ssh -p 21299" ssh.zip root@51.15.75.156:/root/backup 
rm ssh.zip
rsync -azP -e "ssh -p 21299" .zsh_history root@51.15.75.156:/root/backup 
