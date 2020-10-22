#!/bin/sh -ex

mkdir -p /tmp/bin
PROVII=/tmp/bin/provii
PROVII_URL='https://raw.githubusercontent.com/l0xy/provii/master/provii'

curl -sSLo  $PROVII $PROVII_URL
chmod +x $PROVII

$PROVII install \
	fd \
	rg \
	bat \
	lsd \
	tag \
	bandwhich \
	kmon
