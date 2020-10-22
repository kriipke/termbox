#!/bin/sh -ex

# (( o0zi )) :: CONFIGURE SHARED APP DATA 

add_numeric_prefix() {
    local NUMERIC_PREFIX PADLENGTH FILENAME
    NUMERIC_PREFIX=$2
    printf '%03d-%s.sh' $NUMERIC_PREFIX $1
}

SHARED_DIRS_RC=$( add_numeric_prefix systemwide_shared_appdata 2 )
PREFIX=${XDG_DATA_DIRS%%:*}

cat > /etc/profile.d/$SHARED_DIRS_RC <<EOF
#!/bin/sh

# [ o0 ] : non-user-specific app data unique to o0zi,
#   recommended to be installed in /usr/local/share/*

export \
    COLORS_DIR \
    LNAV_DIR \
    VIM_DIR \
    TMUX_DIR \
    NAVI_DIR

COLORS_DIR=${PREFIX:?}/color-palettes
LNAV_DIR=${PREFIX:?}/lnav
TMUX_DIR=${PREFIX:?}/tmux
VIM_DIR=${PREFIX:?}/vim/vimfiles
NAVI_DIR=${PREFIX:?}/cheats
EOF

. /etc/profile.d/$SHARED_DIRS_RC

mkdir -pm 0644 $COLORS_DIR
mkdir -pm 0644 $LNAV_DIR
mkdir -pm 0644 $TMUX_DIR
mkdir -pm 0644 $VIM_DIR
mkdir -pm 0644 $NAVI_DIR

#
# LNAV
#
dnf install -y lnav
git clone https://github.com/PaulWay/lnav-formats $LNAV_DIR
git clone https://github.com/aspiers/lnav-formats $LNAV_DIR
git clone https://github.com/tstack/lnav-formats $LNAV_DIR

#
# VIM
#
dnf install -y vim
git clone --recursive srv:sys.vim.git $VIM_DIR
ln -s $VIM_DIR/vimrc /etc/vimrc.local

#
# TMUX
#
dnf install -y tmux
git clone --recursive srv:sys.tmux.git $TMUX_DIR
ln -s $TMUX_DIR/tmux.conf /etc/tmux.conf

#
# NAVI
#
URL='https://raw.githubusercontent.com/denisidoro/navi/master/scripts/install'
SOURCE_DIR=$PREFIX/src/navi BIN_DIR=$PREFIX/bin bash <(curl -sL $NAVI_URL)
git clone --recursive srv:cheats.git $NAVI_DIR

