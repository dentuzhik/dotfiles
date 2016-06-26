# shellcheck source=/dev/null

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
if [[ -n $(type brew 2> /dev/null) ]] && [[ -f $(brew --prefix)/share/bash-completion/bash_completion ]]; then
    BASH_COMPLETION_FILE=$(brew --prefix)/share/bash-completion/bash_completion
fi

# Add path for Homebrew cask
export PATH="/usr/local/sbin:$PATH"

# Load bash-completion script
if [ -f "$BASH_COMPLETION_FILE" ]; then
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
BASE_PS1='['$(prompt_blue '\t')']'
PS1=$BASE_PS1' \W '$(prompt_red $'\xe2\x86\x92')' '

if [ -f $GIT_PROMPT_FILE ]; then
    source $GIT_PROMPT_FILE

    export GIT_PS1_SHOWDIRTYSTATE=1
    export GIT_PS1_SHOWCOLORHINTS=1
    # GIT_PS1_SHOWUNTRACKEDFILES=1
    export GIT_PS1_SHOWUPSTREAM='verbose'
    PROMPT_COMMAND='__git_ps1 "'$BASE_PS1' \W" " '$(prompt_red $'\xe2\x86\x92')' "'
fi

if [[ -n $(type brew 2> /dev/null) ]]; then
    PATH=$PATH:$(brew --prefix git)/share/git-core/contrib/diff-highlight
fi

# Loading chpwd hook implementation
source $DOTFILES_HOME/scripts/chpwd.sh

# Redefining cd to export chpwd hook
function cd()
{
    builtin cd "$@"
    chpwd
}

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
export EDITOR='vim'

# Heroku Toolbelt
PATH=$PATH:/usr/local/heroku/bin

# Set up NVM
source $DOTFILES_HOME/scripts/nvm.sh

# Set up npm completion
source $DOTFILES_HOME/scripts/npm_completion.sh

# Set up RVM
export PATH="$PATH:$HOME/.rvm/bin"

# Set up z
# Requires manual installation of z via brew
source $(brew --prefix)/etc/profile.d/z.sh

# Set up scm_breeze
source $DOTFILES_HOME/scripts/scm_breeze.sh

# Set up thefuck
eval "$(thefuck --alias)"

# Completion for tmuxp, if available
if [[ -n $(which tmuxp) ]]; then
    eval "$(_TMUXP_COMPLETE=source tmuxp)"
fi

# https://robinwinslow.co.uk/2012/07/20/tmux-and-ssh-auto-login-with-ssh-agent-finally
# We're not in a tmux session
if [ -z "$TMUX" ]; then
    # We logged in via SSH
    if [ ! -z "$SSH_TTY" ]; then

        if [ ! -z "$SSH_AUTH_SOCK" ] && [ "$SSH_AUTH_SOCK" != "$HOME/.ssh/agent_sock" ] ; then
            unlink "$HOME/.ssh/agent_sock" 2>/dev/null
            ln -s "$SSH_AUTH_SOCK" "$HOME/.ssh/agent_sock"
            export SSH_AUTH_SOCK="$HOME/.ssh/agent_sock"
        fi

        # Start tmux, if available
        if [[ -n $(type tmux) ]]; then
            tmux attach || tmux new
        fi
    fi
fi
