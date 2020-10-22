#!/bin/sh -ex

VIM_DIR=/usr/share/vim/vimfiles
REPO_URL='https://github.com/l0xy/vim-config'

rm -rf ${VIM_DIR:?}/*
git clone --recursive $REPO_URL $VIM_DIR/
rm -rf $VIM_DIR/pack/devbox

ln -sf $VIM_DIR/vimrc /etc/vimrc.local
