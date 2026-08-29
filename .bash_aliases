# shellcheck shell=bash

shopt -s expand_aliases

alias vim='nvim'

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias -- -='cd -'
alias dots='cd "$DOTFILES_HOME"'
alias dotnvim='nvim "$DOTFILES_HOME/.config/nvim"'

# Files and text
if ls --color >/dev/null 2>&1; then
    alias ls='ls --color=auto'
else
    alias ls='ls -G'
fi
alias la='ls -A'
alias l='ls -AlhF'
alias grep='grep --color=auto'

if command -v gtar >/dev/null 2>&1; then
    alias tar='gtar'
fi

if command -v pbcopy >/dev/null 2>&1; then
    alias pbc='pbcopy'
    alias pbp='pbpaste'
elif command -v xclip >/dev/null 2>&1; then
    alias pbc='xclip -selection clipboard'
    alias pbp='xclip -selection clipboard -o'
fi

# Containers
alias dc='docker'
alias dcp='docker compose'
alias dclcnt='docker container prune'
alias dclimg='docker image prune'

# Optional project/session tools
alias tpl='tmuxp load .'

mwb-cat() {
    if [[ $# -ne 1 ]]; then
        printf 'Usage: mwb-cat FILE\n' >&2
        return 2
    fi

    unzip -p -- "$1" document.mwb.xml |
        sed -E 's/_ptr_="[x0-9a-fA-F]{8,18}"/_ptr_=""/'
}
