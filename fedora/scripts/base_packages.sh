#!/bin/sh -ex

dnf install -y \
	git \
	curl \
	vim \
	htop \
	nnn \
	tree \
	tig \
	httpie \
	jq \
	fzf \
	ncdu \
	qrencode \
	ctags-etags \
	bash-completion

cat >>/etc/bashrc <<'EOF'
. /usr/share/fzf/shell/key-bindings.bash
EOF

