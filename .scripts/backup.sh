#!/bin/bash

rsync -azP --delete -e "ssh -p 21299" --exclude-from='/home/vuk/.scripts/backup_exclude' /mnt/PODACI root@51.15.75.156:/root/backup
