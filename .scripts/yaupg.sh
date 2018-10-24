#!/bin/bash

set -e

yay -Syu --combinedupgrade
echo '0' > /home/vuk/.updates
refresh_i3status.sh
sudo find /var/cache/pacman/pkg -mindepth 1 -delete
find /home/vuk/.cache/yay -mindepth 1 -delete
