#!/bin/bash

set -e

yaourt -Syua
echo '0' > /home/vuk/.updates
refresh_i3status.sh
sudo find /var/cache/pacman/pkg -mindepth 1 -delete
