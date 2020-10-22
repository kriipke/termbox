#!/bin/sh -ex

# [ 0o ] configure system-wide shell settings / rc

(( EUID == 0 )) || exit 1

SYSTEMWIDE_USER_DIRS_DEFS='04-systemwide_user_dirs.sh'
cat > /etc/profile.d/$SYSTEMWIDE_USER_DIRS <<'EOF'
#!/bin/sh

# [ o0 ] : user-specific app data that is ubiquitously
#+  configured accross o0zi via /etc/profile & the
#+  structure of /etc/skel

export \
    TRASH_DIR \
    UP_DIR \
    TIG_DIR \
    NNN_DIR

TRASH_DIR=$HOME/.trash
mkdir -pm 0600 $UP_DIR

UP_DIR=$HOME/.cache/up
mkdir -pm 0600 $UP_DIR

TIG_DIR=$HOME/.config/tig
mkdir -pm 0600 $TIG_DIR

NNN_DIR=$HOME/.config/nnn
mkdir -pm 0600 $NNN_DIR
EOF
. /etc/profile.d/$SYSTEMWIDE_USER_DIRS_DEFS

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
# MISCELLANEOUS
#
dnf install -y trash-cli
dnf install -y fd-find ripgrep
dnf install -y exa nnn
dnf install -y bat grc
iinst fzf
iinst up

