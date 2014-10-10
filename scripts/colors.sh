function echo_red() {
    echo -e "\e[1;31m$1\e[0;39m"
}

function echo_yellow() {
    echo -e "\e[1;33m$1\e[0;39m"
}

function echo_blue() {
    echo -e "\e[1;34m$1\e[0;39m"
}

function echo_cyan() {
    echo -e "\e[1;36m$1\e[0;39m"
}

function echo_magenta() {
    echo -e "\e[1;35m$1\e[0;39m"
}

function prompt_red() {
    echo "\[\e[1;31m\]$1\[\e[0;39m\]"
}

function prompt_yellow() {
    echo "\[\e[1;33m\]$1\[\e[0;39m\]"
}

function prompt_blue() {
    echo "\[\e[1;34m\]$1\[\e[0;39m\]"
}

function prompt_cyan() {
    echo "\[\e[1;36m\]$1\[\e[0;39m\]"
}

function prompt_magenta() {
    echo "\[\e[1;35m\]$1\[\e[0;39m\]"
}
