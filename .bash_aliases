shopt -s expand_aliases

# Enable aliases to be sudo'ed
alias sudo="sudo "

# Navigation shortcuts
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias -- -="cd -"

alias dots="cd $DOTFILES_HOME"
alias dotvim="vim ~/.vimrc"

# Detect which `ls` flavor is in use
# GNU `ls`
if ls --color &> /dev/null; then
    colorflag="--color=auto"
# OS X `ls`
else
    colorflag="-G"
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
alias l="ls -AlhFG"

alias h="history"
alias j="jobs"

alias vimod='vim -O $(git diff --name-only --diff-filter=M)'
alias combmod='csscomb $(git diff --name-only --diff-filter=M)'

alias ghcl=github_clone_organization

# Work specific
function wcp_dir {
    echo ~/work/wc${1-1}/web4
}

function wcp {
    cd $(wcp_dir $1)
}

function upw {
    git co -q dev
    git pull --ff-only upstream dev
    git push

    cd - 1> /dev/null
}

alias upw=upw
alias wp=wcp
