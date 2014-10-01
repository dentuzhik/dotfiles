# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

LC_CTYPE='en_US.UTF-8'
LC_ALL='en_US.UTF-8'

# Export path to reference in other scripts
export DOTFILES_HOME=$HOME/dotfiles

. $DOTFILES_HOME/helper_functions.sh

# Load bash_completion script
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

# These files are curl'ed when bootstrapping
GIT_COMPLETION_FILE=~/.git-completion.bash
GIT_PROMPT_FILE=~/.git-prompt.sh

# Load git-completion script
if [ -f $GIT_COMPLETION_FILE ]; then
    . $GIT_COMPLETION_FILE
fi

# A bit fancier PS1
BASE_PS1='['`blue '\t'`' '`yellow '#\#'`']'
PS1=$BASE_PS1' \W '`yellow $'\u2192'`' '

if [ -f $GIT_PROMPT_FILE ]; then
    . $GIT_PROMPT_FILE
    GIT_PS1_SHOWDIRTYSTATE=1
    GIT_PS1_SHOWCOLORHINTS=1
    # GIT_PS1_SHOWUNTRACKEDFILES=1
    GIT_PS1_SHOWUPSTREAM='verbose'
    PROMPT_COMMAND='__git_ps1 "'$BASE_PS1' \W" " '`red $'\u2192'`' "'
fi

# Loading aliases
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth
HISTSIZE=10000

# Append to the history file, don't overwrite it
shopt -s histappend

# Check the window size after each command and, if necessary, update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will  match all files and zero or more directories and subdirectories.
# Suppress any errors on outdated bash
shopt -s globstar 2> /dev/null

# Make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# The one and the only
EDITOR='vim'

# RVM
PATH=$PATH:$HOME/.rvm/bin

# Heroku Toolbelt
PATH=$PATH:/usr/local/heroku/bin

# Set up NVM
export NVM_DIR="/home/dentuzhik/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
