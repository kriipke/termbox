#!/bin/sh

# (( o0zi )) :: XDG DIRECTORY CONFIG 

set -x

if [ "$(id -u)" -ne 0 ]; then
	printf "%s\n" "This script must be run as root"
	exit 1
fi

#
# Update system & install XDG packages
#

. /etc/os-release
DISTRO="$( echo "${ID_LIKE-$ID}" | tr '[:upper:]' '[:lower:]' )"

case $DISTRO in
*debian*)
	apt install -y \
		xdg-user-dirs \
		xdg-utils
	;;
*fedora* | *rhel*)
	dnf install -y \
		xdg-user-dirs \
		xdg-utils
	;;
esac

#
# Configure XDG Base Directories
#

old_ifs="$IFS"

IFS=' '
XDG_BASE_DATA='/usr/local/share /usr/share'
for dir in $XDG_BASE_DATA; do
	mkdir -p "$dir" &&
	chmod 0755 "$dir"
done
XDG_BASE_CONFIG='/usr/local/etc /etc/xdg'
for dir in $XDG_BASE_CONFIG; do
	mkdir -p "$dir" &&
	chmod 0755 "$dir"
done
IFS="$old_ifs"

RC_XDG_BASE="/etc/profile.d/001-xdg_dirs_rc.sh"
cat >"$RC_XDG_BASE" <<EOF
#!/bin/sh

# (( o0zi )) :: CONFIGURE XDG BASE DIRS

export XDG_CONFIG_DIRS XDG_DATA_DIRS
XDG_CONFIG_DIRS='$( echo "$XDG_BASE_CONFIG" | tr ' ' ':' )'
XDG_DATA_DIRS='$( echo "$XDG_BASE_DATA" | tr ' ' ':' )'
EOF

. "$RC_XDG_BASE"

#
# Configure XDG User Directories
#

XDG_USER_DOWNLOADS=.dl
XDG_USER_TEMPLATES=templates
XDG_USER_DOCUMENTS=docs
XDG_USER_MUSIC=media/tunes
XDG_USER_PICTURES=media/pics
XDG_USER_VIDEOS=media/video
XDG_USER_SHARED=shared

RC_XDG_USER="${XDG_BASE_CONFIG%% *}/user-dirs.defaults"

cat >"$RC_XDG_USER" <<EOF
DOWNLOAD=$XDG_USER_DOWNLOADS
TEMPLATES=$XDG_USER_TEMPLATES
DOCUMENTS=$XDG_USER_DOCUMENTS
MUSIC=$XDG_USER_MUSIC
PICTURES=$XDG_USER_PICTURES
VIDEOS=$XDG_USER_VIDEOS
PUBLICSHARE=$XDG_USER_SHARED
EOF

xdg-user-dirs-update
