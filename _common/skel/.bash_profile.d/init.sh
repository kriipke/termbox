#!/bin/sh

# initializiation logic for user home creation, run upon first
# login via ~/.bash_profile

ln -sf $HOME/.local/bin $HOME/bin
ln -sf $HOME/.local/share/cheats $HOME/cheats
ln -sf $HOME/.local/share/notes $HOME/notes

# delete this file after running the first time
rm $HOME/.bash_profile.d/init.sh
