function echo_red() {
    echo -e "\033[1;31m$1\033[0;39m"
}

function echo_green() {
    echo -e "\033[1;32m$1\033[0;39m"
}

function echo_yellow() {
    echo -e "\033[1;33m$1\033[0;39m"
}

function echo_blue() {
    echo -e "\033[1;34m$1\033[0;39m"
}

function echo_cyan() {
    echo -e "\033[1;36m$1\033[0;39m"
}

function echo_magenta() {
    echo -e "\033[1;35m$1\033[0;39m"
}

function prompt_red() {
    echo "\[\033[1;31m\]$1\[\033[0;39m\]"
}

function prompt_green() {
    echo "\[\033[1;32m\]$1\[\033[0;39m\]"
}

function prompt_yellow() {
    echo "\[\033[1;33m\]$1\[\033[0;39m\]"
}

function prompt_blue() {
    echo "\[\033[1;34m\]$1\[\033[0;39m\]"
}

function prompt_cyan() {
    echo "\[\033[1;36m\]$1\[\033[0;39m\]"
}

function prompt_magenta() {
    echo "\[\033[1;35m\]$1\[\033[0;39m\]"
}
