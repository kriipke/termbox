# XDG directories

export XDG_CONFIG_HOME=$HOME/.config
if [ ! -d "$XDG_CONFIG_HOME" ]; then
    mkdir -p $XDG_CONFIG_HOME
fi

export XDG_CACHE_HOME=$HOME/.cache
if [ ! -d "$XDG_CACHE_HOME" ]; then
    mkdir -p $XDG_CACHE_HOME
fi

export XDG_CONFIG_DIRS=/etc/xdg:/etc
for dir in $(echo $XDG_CONFIG_DIRS | tr : '\n' ); do
    if [ ! -d $dir ]; then
        mkdir -p $XDG_CONFIG_HOME
    fi
done

export XDG_RUNTIME_DIR=/run/user/$UID



