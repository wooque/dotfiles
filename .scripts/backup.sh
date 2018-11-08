#!/bin/bash

rsync -azP --delete -e "ssh -p 21299" --exclude-from='/mnt/PODACI/.backupignore' /mnt/PODACI root@51.15.75.156:/root/backup
