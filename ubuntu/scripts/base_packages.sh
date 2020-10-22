#!/bin/sh -ex

apt install -y \
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
	exuberant-ctags \
	bash-completion

cp /usr/share/doc/fzf/examples/completion.bash \
	/etc/bash_completion.d/fzf.bash-completion

cat >>/etc/bash.bashrc <<'EOF'
. /usr/share/doc/fzf/examples/key-bindings.bash
EOF
