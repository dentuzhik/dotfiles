# If not running interactively, don't do anything
case $- in
    *i*) ;;
    *) return;;
esac

export LC_CTYPE='en_US.UTF-8'
export LC_ALL='en_US.UTF-8'
export LANG='en_US.UTF-8'

# Export path to reference in other scripts
export DOTFILES_HOME=~/dotfiles

source $DOTFILES_HOME/scripts/helpers.sh

# Default bash-completion script
BASH_COMPLETION_FILE=/etc/bash_completion

# If default script is not found, try to replace it with Brew version
if [[ -n $(type brew 2> /dev/null) ]]; then
    BASH_COMPLETION_FILE=$(brew --prefix)$BASH_COMPLETION_FILE
fi

# Load bash-completion script
if [ -f $BASH_COMPLETION_FILE ]; then
    source $BASH_COMPLETION_FILE
fi

# These files are curl'ed when bootstrapping
GIT_COMPLETION_FILE=~/.git-completion.bash
GIT_PROMPT_FILE=~/.git-prompt.sh

# Load git-completion script
if [ -f $GIT_COMPLETION_FILE ]; then
    source $GIT_COMPLETION_FILE
fi

# A bit fancier PS1
BASE_PS1='['`prompt_blue '\t'`' '`prompt_yellow '#\#'`']'
PS1=$BASE_PS1' \W '`prompt_red $'\xe2\x86\x92'`' '

if [ -f $GIT_PROMPT_FILE ]; then
    source $GIT_PROMPT_FILE

    GIT_PS1_SHOWDIRTYSTATE=1
    GIT_PS1_SHOWCOLORHINTS=1
    # GIT_PS1_SHOWUNTRACKEDFILES=1
    GIT_PS1_SHOWUPSTREAM='verbose'
    PROMPT_COMMAND='__git_ps1 "'$BASE_PS1' \W" " '`prompt_red $'\xe2\x86\x92'`' "'
fi

# Loading aliases
if [ -f ~/.bash_aliases ]; then
    source ~/.bash_aliases
fi

# Don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth
HISTSIZE=10000

# Append to the history file, don't overwrite it
shopt -s histappend

# Check the window size after each command and, if necessary, update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If command is a valid directory name, cd to it
# Suppress any errors on outdated bash
shopt -s autocd 2> /dev/null

# Corrects minor errors in directories names
# Suppress any errors on outdated bash
shopt -s cdspell dirspell 2> /dev/null

# Enables regexp-like repetition characters
# ?(patterns-list) - zero or one patterns
# *(patterns-list) - zero or more patterns
# +(patterns-list) - one or more patterns
# @(patterns-list) - one of the patterns
# !(patterns-list) - everything expect patterns
shopt -s extglob

# Exapnd '**' to all files and directories recursively
# Suppress any errors on outdated bash
shopt -s globstar 2> /dev/null

# Make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# The one and the only
EDITOR='vim'

# Heroku Toolbelt
PATH=$PATH:/usr/local/heroku/bin

# Set up NVM
export NVM_DIR=~/.nvm
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

# Set up RVM
export PATH="$PATH:$HOME/.rvm/bin"
