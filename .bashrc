# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# Export path to reference in other scripts
export DOTFILES_HOME=$HOME/dotfiles

# Loading aliases
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

LC_ALL='en_US.UTF-8'

# Don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth
HISTSIZE=10000

# Append to the history file, don't overwrite it
shopt -s histappend

# Check the window size after each command and, if necessary, update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will  match all files and zero or more directories and
# subdirectories.
shopt -s globstar

# Make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# The one and the only
EDITOR='vim'

# A bit fancier PS1
PS1="[\[\033[1;31m\]!\!\[\033[0;39m\]] \W\$ "

# RVM
PATH=$PATH:$HOME/.rvm/bin

# Heroku Toolbelt
PATH=$PATH:/usr/local/heroku/bin

# Set up NVM
export NVM_DIR="/home/dentuzhik/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
