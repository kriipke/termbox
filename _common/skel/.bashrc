# ~/.bashrc: executed by bash(1) for non-login shells.

PATH="$PATH:/usr/local/bin:$HOME/.local/bin"

# source global definitions
# NOTE: this file is /etc/bash.bashrc in ubuntu
if [[ -r /etc/bashrc && -z $BASHRCSOURCED ]]; then
    . /etc/bashrc
fi

if [ -r ~/.bash_aliases ]; then
    source $HOME/.bash_aliases
fi

if [ -d ~/.bashrc.d ]; then
    . $HOME/.bashrc.d/*
fi
