#!/bin/sh -ex

# (( o0zi )) :: CONFIGURE USER APP DATA 

[ "$(id -u)" -ne 0 ] || exit 1

SYSTEMWIDE_USER_DIRS='04-systemwide_user_dirs.sh'
cat > /etc/profile.d/$SYSTEMWIDE_USER_DIRS <<'EOF'
#!/bin/sh

# [ o0 ] : user-specific app data that is ubiquitously
#+  configured accross o0zi via /etc/profile & the
#+  structure of /etc/skel

export TRASH_DIR UP_DIR TIG_DIR NNN_DIR

TRASH_DIR=$HOME/.trash
if [ ! -d "$TRASH_DIR" ]; then
    mkdir -m 0700 $TRASH_DIR
fi

UP_DIR=$HOME/.cache/up
if [ ! -d "$UP_DIR" ]; then
    mkdir -m 0700 $UP_DIR
fi

TIG_DIR=${PREFIX:?}/tig

NNN_DIR=$HOME/.config/nnn
mkdir -pm 0600 $NNN_DIR
EOF

. /etc/profile.d/$SYSTEMWIDE_USER_DIRS

mkdir -pm 0644 $TIG_DIR

#
# TIG
#
git init $TIG_DIR && cd $TIG_DIR
git fetch -t https://github.com/jonas/tig
git reset --hard $( git tag | tail -1 )

make configure
./configure

## add TIG_USER_CONF=/etc/xdg/tig/tigrc to $TIG_DIR/contrib/config.make
## uncomment NO_BUILTIN_TIGRC  in $TIG_DIR/contrib/config.make

make prefix=${PREFIX%/share}
make install prefix=${PREFIX%/share}

dnf install -y asciidoc xmlto
make prefix=${PREFIX%/share} install-doc

## INSTALL contrib/tig-pick INTO /ETC/BASHRC.D & GIVE IT A KEYBINDING

install $TIG_DIR/contrib/tig-completion.bash /etc/bash-completion.d/
cp $TIG_DIR/contrib/vim.tigrc ${XDG_CONFIG_DIRS%%:*}/tig/
echo 'source ./vim.tigrc' >> ${XDG_CONFIG_DIRS%%:*}/tig/tigrc


#
# PROVII
#
PROVII_DIR=$HOME/.cache/provii
mkdir -p $PROVII_DIR && cd $PROVII_DIR
git clone $REPO_HOST:provii.git .
chmod +x provii && ./provii install provii

#
# SYS.SHELL
#
# NOTE: ONCE THIS PACKER REPO GETS TAGGED THE TAG
# BEING PULLED FROM  THIS REPO NEEDS TO BE HARD CODED IN
cd /etc && git init
git remote add origin $REPO_HOST:sys.shell.git
git fetch && git reset --hard HEAD
git branch --track origin master


#
# TRASH-CLI
#
dnf install -y trash-cli

#
# NNN
#
dnf install -y exa nnn

dnf install -y fd-find ripgrep
dnf install -y bat grc
iinst fzf
iinst up

