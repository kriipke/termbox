#!/bin/sh

# (( o0zi )) 

set -x

dnf install -y \
	git \
	curl \
	vim \
	nnn \
	tree \
	tig \
	httpie \
	jq \
	ncdu \
	qrencode \
	fd-find \
	lsd \
	fzf 

cat >>/etc/bashrc <<'EOF'
. /usr/share/fzf/shell/key-bindings.bash
EOF
