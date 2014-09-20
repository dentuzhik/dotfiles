# Enable aliases to be sudo’ed
alias sudo='sudo '

# Navigation shortcuts
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias -- -="cd -"

# Detect which `ls` flavor is in use
# GNU `ls`
if ls --color &> /dev/null; then
    colorflag="--color=auto"
# OS X `ls`
else
    colorflag="-G"
fi

alias ls="ls ${colorflag}"
alias l="ls -AlhFG"
alias la="ls -A"

alias h="history"
alias j="jobs"

alias vimod='vim -O `git diff --name-only --diff-filter=M`'
