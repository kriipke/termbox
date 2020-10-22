#!/bin/sh -ex

# (( o0zi )) :: CONFIGURE TEMPORARY SSH ACCESS
#
#   The following variables should be provided by Packer:
#      - PACKER_ENC_KEY
#      - PACKER_SHARED_DIR

SSH_KEY_ENC_KEY=${GIT_SERVER_KEYS:?}
PACKER_SHARED_DIR=${PACKER_SHARED_DIR:?}

#
# Download packages for keychain
#

. /etc/os-release
DISTRO="$(echo "${ID_LIKE-$ID}" | tr '[:upper:]' '[:lower:]')"

case $DISTRO in
*debian*)
  apt install -y keychain
  ;;
*fedora* | *rhel*) 
  dnf install -y keychain expect openssh-clients
  ;;
esac

#
# Decrypt & extract files needed to use Keychain
#

OUTFILE=${XDG_CACHE_HOME}/packer_rsa.tar
if [ -r "$OUTFILE" ]; then
  rm -f "$OUTFILE"
fi
gpg2 --batch --decrypt \
  --passphrase "$SSH_KEY_ENC_KEY" \
  --output "${XDG_CACHE_HOME}"/packer_rsa.tar \
  "$PACKER_SHARED_DIR"/packer_rsa.tar.enc

mkdir -p "${SSH_DIR:=$HOME/.ssh}"
tar -xOf packer_rsa.tar packer_rsa >"$SSH_DIR"/packer_rsa
tar -xOf packer_rsa.tar packer_rsa.pub >"$SSH_DIR"/packer_rsa.pub

cat >"$SSH_DIR"/known_hosts <<'EOF'
|1|X4SVtoJvZ5yP0sP7JL1qVORjIDc=|BuuNxbH3arWQqGnZ8j+lRu6PUlM= ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBGXjIet9IGmGNJNh6pAp08iROt0TDwVQgOp0Eo+qNBapLuKFVa7rxbHTa2kOdwpZxn+zdCDreWAOVp6u80J1oMk=
|1|+LPpn5nOIMNbhu8F4+IZ2voARGA=|Z1/CfU2Zzw/FlLvnaqL8vKR0DIA= ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBGXjIet9IGmGNJNh6pAp08iROt0TDwVQgOp0Eo+qNBapLuKFVa7rxbHTa2kOdwpZxn+zdCDreWAOVp6u80J1oMk=
|1|pq7iEA5txTVZuKuMxLDsa+GIBvc=|X4KnVMBm+vAraogk4vXGVQ58fWk= ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBD9QJPeGrfZW3TOn3syXCNdrhPY0umj6XM5l0v1okqR2RjrtygBxHP01jNhnLdKwWDWjd15Ui6Xtkok5PPFsD2o=
EOF

#
# Configure SSH
#

cat >"$SSH_DIR"/config <<EOF
Host srv
    Hostname 10.108.0.3
    User git
    ProxyCommand ssh -W %h:%p packer@o0.lc
    IdentitiesOnly yes
    IdentityFile $SSH_DIR/packer_rsa
EOF

# the permissions have to be correct before adding
# the key to the keychain below
chown -R "$(id -u)":"$(id -g)" "$SSH_DIR"
chmod -R go-rwsx "$SSH_DIR"

#
# Configure Keychain
#

SSH_KEY_PASS=$(tar -xOf packer_rsa.tar packer_rsa.passwd)
echo "$SSH_KEY_PASS"
/bin/expect -c "

spawn /usr/bin/keychain $HOME/.ssh/packer_rsa

expect passphrase { send {$SSH_KEY_PASS}; send \r }
"

. "${HOME}/.keychain/${HOST}-sh"
