# Fig pre block. Keep at the top of this file.
[[ -f "$HOME/.fig/shell/bashrc.pre.bash" ]] && builtin source "$HOME/.fig/shell/bashrc.pre.bash"

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
    eval "$(/opt/homebrew/bin/brew shellenv)"
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

# The king is dead, long live the king
export EDITOR='nvim'

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

# Z integration with fzf-tmux
unalias z 2> /dev/null
z() {
  [ $# -gt 0 ] && _z "$*" && return
    cd "$(_z -l 2>&1 | fzf-tmux +s --tac --query "$*" | sed 's/^[0-9,.]* *//')"
}

# Set up scm_breeze
# source $DOTFILES_HOME/scripts/scm_breeze.sh

# Set up thefuck
eval "$(thefuck --alias)"

export EVENT_NOKQUEUE=1

if [[ ! -d $HOME/.vim/undodir ]]; then
    mkdir ~/.vim/undodir
fi

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

if [[ -n $(which yarn) ]]; then
    YARN_PATH=$(yarn global bin)
    export PATH=$PATH:$YARN_PATH
fi

export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# This loads nvm bash_completion
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

###-begin-graphql-completions-###
#
# yargs command completion script
#
# Installation: graphql completion >> ~/.bashrc
#    or graphql completion >> ~/.bash_profile on OSX.
#
_yargs_completions()
{
    local cur_word args type_list

    cur_word="${COMP_WORDS[COMP_CWORD]}"
    args=("${COMP_WORDS[@]}")

    # ask yargs to generate completions.
    type_list=$(graphql --get-yargs-completions "${args[@]}")

    COMPREPLY=( $(compgen -W "${type_list}" -- ${cur_word}) )

    # if no match was found, fall back to filename completion
    if [ ${#COMPREPLY[@]} -eq 0 ]; then
      COMPREPLY=( $(compgen -f -- "${cur_word}" ) )
    fi

    return 0
}
complete -F _yargs_completions graphql
###-end-graphql-completions-###

# Initilaise fasd
fasd_cache="$HOME/.fasd-init-bash"
if [ "$(command -v fasd)" -nt "$fasd_cache" -o ! -s "$fasd_cache" ]; then
  fasd --init posix-alias bash-hook bash-ccomp bash-ccomp-install >| "$fasd_cache"
fi
source "$fasd_cache"
unset fasd_cache

export PATH="$HOME/dotfiles/fzf-fs:$PATH"

export PNPM_HOME="/Users/dentuzhik/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"

if command -v pyenv 1>/dev/null 2>&1; then
    eval "$(pyenv init --path)"
fi

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/dentuzhik/opt/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/dentuzhik/opt/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/dentuzhik/opt/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/dentuzhik/opt/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# Fig post block. Keep at the bottom of this file.
[[ -f "$HOME/.fig/shell/bashrc.post.bash" ]] && builtin source "$HOME/.fig/shell/bashrc.post.bash"
