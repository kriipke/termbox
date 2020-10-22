#!/bin/sh

# (( o0zi )) :: LINUX VIRTUAL TERMINAL CONFIG

set -x

FONT='ter-powerline-v16n'
COLORSCHEME='bright'

. /etc/os-release
DISTRO="$(echo "${ID_LIKE-$ID}" | tr '[:upper:]' '[:lower:]')"

case "$DISTRO" in
*debian*)
  apt install -y kitty-terminfo
  CONSOLEFONTS_DIR=/usr/share/consolefonts
  KEYMAPS_DIR=/usr/share/keymaps
  SETVTRGB=/usr/sbin/setvtrgb
  ;;
*fedora* | *rhel*)
  dnf install -y kbd kbd-misc kitty-terminfo
  CONSOLEFONTS_DIR=/lib/kbd/consolefonts
  KEYMAPS_DIR=/lib/kbd/keymaps
  SETVTRGB=/usr/bin/setvtrgb
  ;;
esac

#
#   CONSOLE FONT
#
FONT_URL='https://github.com/powerline/fonts/raw/master/Terminus/PSF'
cd $CONSOLEFONTS_DIR || exit 1
curl -LO $FONT_URL/ter-powerline-v16n.psf.gz
curl -LO $FONT_URL/ter-powerline-v16b.psf.gz
curl -LO $FONT_URL/ter-powerline-v16v.psf.gz

#
#   KEYMAP
#
KEYCODE_ESC=1
KEYCODE_CAPS_LOCK=58
KEYCODE_L_WIN=125
KEYCODE_R_CTRL=97

mkdir -p $KEYMAPS_DIR/0o

cat >>$KEYMAPS_DIR/0o/ava.map <<EOF
# swap keys
keycode $KEYCODE_ESC = Caps_Lock
keycode $KEYCODE_CAPS_LOCK = Escape
# Control-R: tmux prefix
plain keycode $KEYCODE_R_CTRL = F35
# C-y: readline prefix
plain keycode $KEYCODE_L_WIN = Control_y
# C-b: tmux prefix (remote hosts)
alt keycode $KEYCODE_L_WIN = Control_b
EOF

#
#   VT COLORS
#
COLORS_DIR=/usr/local/share/colors
echo 'export COLORS_DIR=/usr/local/share/colors' >/etc/profile.d/sh.local
mkdir -p $COLORS_DIR
cd $COLORS_DIR || exit 1
cat >monochrome.rgb <<EOF
13,153,251,73,255,234,202,160,201,217,221,114,79,99,80,189
13,153,251,73,255,234,202,160,201,217,221,114,79,99,80,189
13,153,251,73,255,234,202,160,201,217,221,114,79,99,80,189
EOF
cat >bright.rgb <<EOF
21,153,206,255,4,131,10,226,102,255,204,255,72,190,99,243
21,153,227,231,138,60,193,226,102,0,255,159,198,103,231,243
21,153,24,85,199,159,205,226,102,160,0,0,255,225,240,243
EOF

mkdir -p /etc/profile.d
cat >/etc/systemd/system/vtcolors@.service <<EOF
[Unit]
Description=set colorscheme for virtual terminal to %i at startup
Needs=getty.service

[Service]
Type=simple
ExecStart=$SETVTRGB $COLORS_DIR/%i.rgb
ExecStartPost=/bin/sh -c "/usr/bin/echo 'export COLORSCHEME=%i' > /etc/profile.d/colorscheme.sh"

[Install]
WantedBy=basic.target
EOF
systemctl enable vtcolors@${COLORSCHEME-bright}.service
systemctl start vtcolors@${COLORSCHEME-bright}.service

#
#  /ETC/VCONSOLE.CONF
#
cat >/etc/vconsole.conf <<EOF
KEYMAP="ava"
FONT="${FONT:-'ter-powerline-v16n'}"
EOF

#
#  INPUTRC
#
cat >/etc/inputrc <<'EOF'
set input-meta off
set convert-meta on
set output-meta off
set keyseq-timeout 400
set revert-all-at-newline on
"\C-a":  beginning-of-line
"\C-e":  end-of-line
"\t": menu-complete
"\e[Z": menu-complete-backward
set completion-ignore-case on
set completion-map-case on
set menu-complete-display-prefix on
set colored-completion-prefix off
set show-all-if-ambiguous on
set page-completions on
set visible-stats on
set colored-stats on
set expand-tilde on
set skip-completed-text on
set mark-symlinked-directories on
set mark-directories on
set colored-stats on
set horizontal-scroll-mode on
set bell-style none
set editing-mode vi
set show-mode-in-prompt on
set vi-cmd-mode-string "*"
set vi-ins-mode-string " "
EOF

cat >/etc/profile.d/50-readline.sh <<'EOF'
#!/bin/sh

# (( o0zi )) :: READLINE CONFIGURATION

export INPUTRC
INPUTRC=/etc/inputrc
bind -f $INPUTRC
EOF

cat >/etc/profile.d/50-vt_prompt.sh <<'EOF'
#!/bin/sh

# (( o0zi )) :: LINUX VT PROMPT

if command -v tput > /dev/null 2>&1; then
    if [ $(($(tput colors 2> /dev/null))) -ge 8 ]; then
        export TPUT_BLACK="$(tput setaf 0)"
        export TPUT_RED="$(tput setaf 1)"
        export TPUT_GREEN="$(tput setaf 2)"
        export TPUT_YELLOW="$(tput setaf 3)"
        export TPUT_BLUE="$(tput setaf 4)"
        export TPUT_MAGENTA="$(tput setaf 5)"
        export TPUT_CYAN="$(tput setaf 6)"
        export TPUT_GRAY="$(tput setaf 7)"
        export TPUT_BGBLACK="$(tput setab 0)"
        export TPUT_BGRED="$(tput setab 1)"
        export TPUT_BGGREEN="$(tput setab 2)"
        export TPUT_BGYELLOW="$(tput setab 3)"
        export TPUT_BGBLUE="$(tput setab 4)"
        export TPUT_BGMAGENTA="$(tput setab 5)"
        export TPUT_BGCYAN="$(tput setab 6)"
        export TPUT_BGGRAY="$(tput setab 7)"
        export TPUT_RESET="$(tput sgr 0)"
    fi

    export TPUT_BOLD="$(tput bold)"
    export TPUT_UNDERLINE="$(tput smul)"
    export TPUT_BLINK="$(tput blink)"
    export TPUT_DIM="$(tput dim)"
    export TPUT_REVERSE="$(tput rev)"
fi

#
# PROMPT FORMATTING
#

COLOR_WORKING_DIR="$TPUT_CYAN"
COLOR_ACCENTS="$TPUT_GRAY"

PROMPT_LINE_1="\u@\h:$COLOR_WORKING_DIR\w"
if [ $( id -u ) -eq 0 ]; then
        PROMPT_LINE_2="# "
else
        PROMPT_LINE_2="$ "
fi

# ┌: \342\224\214
# ─: \342\224\200
# └: \342\224\224

export BOX_TR='\342\224\214'
export BOX_HORIZ='\342\224\200'
export BOX_BL='\342\224\224'

PS1="$( printf "$COLOR_ACCENTS\n $BOX_TR$BOX_HORIZ$BOX_HORIZ%s$COLOR_ACCENTS\n$BOX_BL$BOX_HORIZ$BOX_HORIZ%s" \
        "$PROMPT_LINE_1" \
        "$PROMPT_LINE_2"
)"
EOF
