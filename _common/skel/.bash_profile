# o0.lc - $HOME/.bash_profile

# loaded upon user login, note: whem ~/.bash_profile
# exists, bash does not attempt to load ~/.profile

export XDG_CACHE_HOME=$HOME/.cache
if [ ! -d $XDG_CACHE_HOME ]; then
    mkdir -p $XDG_CACHE_HOME
fi

export XDG_CONFIG_HOME=$HOME/.config
if [ ! -d $XDG_CONFIG_HOME ]; then
    mkdir -p $XDG_CONFIG_HOME
fi

export XDG_CONFIG_DIRS=/etc/xdg
if [ ! -d $XDG_CONFIG_DIRS ]; then
    mkdir -p $XDG_CONFIG_DIRS
fi

export XDG_DATA_DIRS=/usr/local/share
if [ ! -d $XDG_DATA_DIRS ]; then
    mkdir -p $XDG_DATA_DIRS
fi

CDPATH=".:~:~/repo.d:~/src.d:~/img.d"

if [ -d ~/.bash_profile.d ]; then
	. ~/.bash_profile.d/*
fi

if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi
