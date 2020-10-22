#!/bin/sh -ex

# [ 0o ] :: /ETC/SKEL

cd /etc/skel && git init
git remote add origin srv:skel.git
git fetch && git reset --hard HEAD
git branch --track origin master
