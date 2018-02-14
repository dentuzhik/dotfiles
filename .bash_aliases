shopt -s expand_aliases

alias vim='nvim'
# Enable aliases to be sudo'ed
alias sudo="sudo "

# Navigation shortcuts
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias -- -="cd -"

alias dots="cd $DOTFILES_HOME"
alias dotvim="vim $DOTFILES_HOME/.vimrc"
alias dotnvim="vim $DOTFILES_HOME/.nvim/init.vim"

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

alias dc=docker
alias dcp=docker-compose
alias ghcl=github_clone_organization
alias dclimg="docker images -q --filter dangling=true | xargs docker rmi"

mwb-cat() {
unzip -p $1 document.mwb.xml | sed -E 's/_ptr_="[x0-9a-fA-F]{8,18}"/_ptr_=""/'
}

if [ -f ~/.airlane_dev_oauth_token ]; then
    AAT=$(cat ~/.airlane_dev_oauth_token)
    function req() {
        http "$@" "Authorization: $AAT"
    }
fi

alias tpl='tmuxp load .'

# Always use fzf-tmux executable
alias fzf='fzf-tmux -d 30'
alias fzf-tmux='fzf-tmux -d 30'

# GIT heart FZF
# -------------

is_in_git_repo() {
    git rev-parse HEAD > /dev/null 2>&1
}

# fe [FUZZY PATTERN] - Open the selected file with the default editor
#   - Bypass fuzzy finder if there's only one match (--select-1)
#   - Exit if there's no match (--exit-0)
function fe() {
    local files

    if [[ $(is_in_git_repo)  ]]; then
        IFS=$'\n' files=($(ag -l --nocolor -f --nogroup --hidden -g "" | fzf-tmux --query "$1" --multi --select-1 --exit-0))
    else
        IFS=$'\n' files=($(git ls-files . -co --exclude-standard | fzf-tmux --query "$1" --multi --select-1 --exit-0))
    fi

    [[ -n "$files" ]] && ${EDITOR:-vim} "${files[@]}"
}

# Modified version where you can press
#   - CTRL-O to open with `open` command,
#   - CTRL-E or Enter key to open with the $EDITOR
function fo() {
    local out file key
    IFS=$'\n' out=($(fzf-tmux --query="$1" --exit-0 --expect=ctrl-o,ctrl-e))
    key=${out[0]}
    file=${out[1]}
    if [ -n "$file" ]; then
        [ "$key" = ctrl-o ] && open "$file" || ${EDITOR:-vim} "$file"
    fi
}


vimod() {
    is_in_git_repo || return
    local files
    IFS=$'\n' files=($({ echo "$(git diff --cached --name-only)" ; echo "$(git ls-files --modified --others --exclude-standard)" ; } | fzf-tmux --multi --select-1 --exit-0))
    [[ -n "$files" ]] && vim -O "${files[@]}"
}

fgs() {
    git -c color.status=always status --short |
        fzf-tmux -m --ansi --nth 2..,.. \
        --preview '(git diff --color=always -- {-1} | sed 1,4d; cat {-1}) | head -500' |
        cut -c4- | sed 's/.* -> //'
}

fgb() {
    is_in_git_repo || return
    git branch -a --color=always | grep -v '/HEAD\s' | sort |
        fzf-tmux --ansi --multi --tac --preview-window right:70% \
        --preview 'git l --color=always $(sed s/^..// <<< {} | cut -d" " -f1) | head -'$LINES |
        sed 's/^..//' | cut -d' ' -f1 |
        sed 's#^remotes/##'
}

fgt() {
    is_in_git_repo || return
    git tag --sort -version:refname |
        fzf-tmux --multi --preview-window right:70% \
        --preview 'git show --color=always {} | head -'$LINES
}

fgh() {
    is_in_git_repo || return
    git log --date=short --format="%C(green)%C(bold)%cd %C(auto)%h%d %s (%an)" --graph --color=always |
        fzf-tmux --ansi --no-sort --reverse --multi --bind 'ctrl-s:toggle-sort' \
        --header 'Press CTRL-S to toggle sort' \
        --preview 'grep -o "[a-f0-9]\{7,\}" <<< {} | xargs git show --color=always | head -'$LINES |
        grep -o "[a-f0-9]\{7,\}"
}

fgr() {
    is_in_git_repo || return
    git remote -v | awk '{print $1 "\t" $2}' | uniq |
        fzf-tmux --tac \
        --preview 'git log --oneline --graph --date=short --pretty="format:%C(auto)%cd %h%d %s" {1} | head -200' |
        cut -d$'\t' -f1
}

fct() {
    local tags target
    tags=$(git tag | awk '{print "\x1b[31;1mtag\x1b[m\t" $1}') || return
    target=$(
    echo "$tags" |
        fzf-tmux -d30 -- --no-hscroll --ansi +m -d "\t" -n 2) || return
    git checkout $(echo "$target" | awk '{print $2}')
}

fco() {
    local branches target

    branches=$(
    git branch --all | grep -v HEAD             |
        sed "s/.* //"    | sed "s#remotes/[^/]*/##" |
        sort -u          | awk '{print "\x1b[34;1mbranch\x1b[m\t" $1}') || return

    target=$(
    echo "$branches" |
        fzf-tmux -d30 --query="$1" -- --no-hscroll --ansi +m -d "\t" -n 2) || return
    git checkout $(echo "$target" | awk '{print $2}')
}

fst() {
    local out k reflog
    out=(
    $(git stash list --pretty='%C(yellow)%gd %>(14)%Cgreen%cr %C(blue)%gs' |
        fzf --ansi --no-sort --header='enter:show, ctrl-d:diff, ctrl-o:pop, ctrl-y:apply, ctrl-x:drop' \
        --preview='git stash show --color=always -p $(cut -d" " -f1 <<< {}) | head -'$LINES \
        --preview-window=down:50% --reverse \
        --bind='enter:execute(git stash show --color=always -p $(cut -d" " -f1 <<< {}) | less -r > /dev/tty)' \
        --bind='ctrl-d:execute(git diff --color=always $(cut -d" " -f1 <<< {}) | less -r > /dev/tty)' \
        --expect=ctrl-o,ctrl-y,ctrl-x))
    k=${out[0]}
    reflog=${out[1]}
    [ -n "$reflog" ] && case "$k" in
    ctrl-o) git stash pop $reflog ;;
    ctrl-y) git stash apply $reflog ;;
    ctrl-x) git stash drop $reflog ;;
esac
}

fsw() {
    git log --graph --color=always \
        --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
        fzf --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort \
        --bind "ctrl-m:execute:
    (grep -o '[a-f0-9]\{7\}' | head -1 |
        xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
    {}
    FZF-EOF"
}


bind '"\er": redraw-current-line'
bind '"\C-g\C-f": "$(fgs)\e\C-e\er"'
bind '"\C-g\C-b": "$(fgb)\e\C-e\er"'
bind '"\C-g\C-t": "$(fgt)\e\C-e\er"'
bind '"\C-g\C-h": "$(fgh)\e\C-e\er"'
bind '"\C-g\C-r": "$(fgr)\e\C-e\er"'
