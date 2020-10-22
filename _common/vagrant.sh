#!/bin/sh -eux

# chef/bento:

/usr/sbin/groupadd vagrant
/usr/sbin/useradd vagrant -g vagrant -G wheel
echo "vagrant" | passwd --stdin vagrant
echo "vagrant        ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers

mkdir -pm 0700 /home/vagrant/.ssh
PUBKEY_URL='https://raw.githubusercontent.com/hashicorp/vagrant/master/keys/vagrant.pub'
AUTHZD_KEYS=/home/vagrant/.ssh/authorized_keys

if command -v wget; then
    wget --no-check-certificate "$PUBKEY_URL" -O "$AUTHZD_KEYS"
elif command -v curl; then
    curl --insecure --location "$PUBKEY_URL" > "$AUTHZD_KEYS"
else
    echo Cannot download vagrant public key
    exit 1
fi

chown -R vagrant:vagrant $HOME_DIR/.ssh
chmod -R go-rwsx $HOME_DIR/.ssh

