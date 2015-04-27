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

if [[ -z $(type pbcopy 2> /dev/null) ]]; then
    alias pbcopy='xclip -selection clipboard'
    alias pbpaste='xclip -selection clipboard -o'
fi

# Assumes that appropriate listener is launched on local machine
alias rcopy='cat | nc -q1 localhost 2224'

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
