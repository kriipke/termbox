#!/bin/sh -ex

# (( o0zi )) :: BOURNE SHELL

PREFIX=${PREFIX:-/usr/local}
SRC_URL='https://sourceforge.net/projects' \
	'/schilytools/files/latest/download'

SH_VARIANTS='sh pbosh'

cd "$(mktemp -d)"
curl -sSL "$SRC_URL" | tar -xj --strip=1 -
make

IFS=' '
for VARIANT in $SH_VARIANTS; do
	cd "$VARIANT"/OBJ/*/
	install ./"$VARIANT" "$PREFIX"/bin/
	install ./man/"${VARIANT}.1" "$PREFIX"/share/man/man1/
done
