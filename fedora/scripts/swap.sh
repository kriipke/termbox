#!/bin/bash -eux

# add 4GB swap file since we didn't setup a swap partition
dd if=/dev/zero of=/swapfile bs=1M count=4096
mkswap /swapfile
swapon /swapfile
echo -e "/swapfile\tswap\tswap\tdefaults\t0\t0" >> /etc/fstab
