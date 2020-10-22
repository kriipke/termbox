#!/bin/sh

if command -v lsd >/dev/null 2>&1; then
	# aliases: ls -> lsd
	alias ls='lsd --icon=never -F'
	alias ll='lsd --icon=never --group-dirs=first -alF'
	alias la='lsd --icon=never -A'
	alias l='lsd --icon=never -F'
else
	# aliases: ls -> ls
	alias ll='ls -alF'
	alias la='ls -A'
	alias l='ls -CF'
fi
