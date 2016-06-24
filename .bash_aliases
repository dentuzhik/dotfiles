shopt -s expand_aliases

# Enable aliases to be sudo'ed
alias sudo="sudo "

# Navigation shortcuts
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias -- -="cd -"

alias dots="cd $DOTFILES_HOME"
alias dotvim="cd $DOTFILES_HOME; vim $DOTFILES_HOME/.vimrc"

# Detect which `ls` flavor is in use
# GNU `ls`
if ls --color &> /dev/null; then
    colorflag="--color=auto"
# OSX `ls`
else
    colorflag="-G"
fi

# GNU 'stat'
if stat -c "%a %n" &> /dev/null; then
    statoptions='-c "%A %a %n"'
# OSX `stat`
else
    statoptions='-f "%A %a %N"'
fi

if [[ -z $SSH_TTY ]]; then
    if [[ -z $(type pbcopy 2> /dev/null) ]]; then
        alias pbcopy='xclip -selection clipboard'
        alias pbpaste='xclip -selection clipboard -o'
    fi
else
    # Assumes that appropriate listener is launched on local machine
    alias pbcopy='cat | nc localhost 2224'
fi

alias pbc='pbcopy'
alias pbp='pbpaste'

alias grep="grep --color=auto"
alias egrep="egrep --color=auto"
alias rgrep="rgrep --color=auto"

alias ls="ls ${colorflag}"
alias la="ls -A"
alias lo="stat ${statoptions}"
alias l="ls -AlhFG"

alias h="history"
alias j="jobs"

alias ghcl=github_clone_organization
alias t=testlio
