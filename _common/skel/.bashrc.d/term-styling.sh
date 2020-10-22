# o0 - shell configuration

# exports text-color vars & sets the following terminal settings:
#     * background color / foreground color
#     * prompt format, i.e. what info prompt contains & in what order
#     * cursor color and shape

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

# all of the cursor shapes below are "hardware cursors" (blinking),
# except 16 which is non-blinking cursor, i.e. "software cursor"

export CURSOR_SHAPE_DEFAULT=0
export CURSOR_SHAPE_NONE=1
export CURSOR_SHAPE_UNDERSCORE=2
export CURSOR_SHAPE_LOWER_THIRD=3
export CURSOR_SHAPE_LOWER_HALF=4
export CURSOR_SHAPE_TWO_THIRDS=5
export CURSOR_SHAPE_BLOCK=6
export CURSOR_SHAPE_SOLID_BLOCK=16

export CURSOR_BG_BLACK=0
export CURSOR_BG_BLUE=16
export CURSOR_BG_GREEN=32
export CURSOR_BG_CYAN=48
export CURSOR_BG_RED=64
export CURSOR_BG_MAGENTA=80
export CURSOR_BG_YELLOW=96
export CURSOR_BG_WHITE=112

export CURSOR_FG_DEFAULT=0
export CURSOR_FG_CYAN=1
export CURSOR_FG_BLACK=2
export CURSOR_FG_GREY=3
export CURSOR_FG_LIGHTYELLOW=4
export CURSOR_FG_WHITE=5
export CURSOR_FG_LIGHTRED=6
export CURSOR_FG_MAGENTA=7
export CURSOR_FG_GREEN=8
export CURSOR_FG_DARKGREEN=9
export CURSOR_FG_DARKBLUE=10
export CURSOR_FG_PURPLE=11
export CURSOR_FG_YELLOW=12
export CURSOR_FG_WHITE=13
export CURSOR_FG_RED=14
export CURSOR_FG_PINK=15

cursor_style="\e[?${CURSOR_SHAPE_BLOCK};${CURSOR_FG_BLACK};${CURSOR_BG_WHITE};c"

prompt_format="${TPUT_CYAN}[${TPUT_WHITE}\u${TPUT_MAGENTA}@\h \w${TPUT_CYAN}]${TPUT_RESET}"

if [ "$TERM" = 'linux' ]; then
    setterm -background black -foreground white -store
    PS1="${prompt_format}${cursor_style}"
else
    PS1="${prompt_format}"
fi
