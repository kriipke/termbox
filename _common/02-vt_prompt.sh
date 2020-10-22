#!/bin/sh

# o0 - shell configuration

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

# ← → ↑ ↓ └ ┌ ─   

WORKING_DIR_COLOR="$TPUT_CYAN"
PROMPT_DECORATION_COLOR="$TPUT_GRAY"

PROMPT_LINE_1="\u@\h:$WORKING_DIR_COLOR\w"

if [ $( id -u ) -eq 0 ]; then
    PROMPT_LINE_2="# "
else
    PROMPT_LINE_2="→ "
fi

PS1="$( printf "$PROMPT_DECORATION_COLOR\n ┌──%s$PROMPT_DECORATION_COLOR\n└──%s" \
	"$PROMPT_LINE_1" \
	"$PROMPT_LINE_2" 
)"	
