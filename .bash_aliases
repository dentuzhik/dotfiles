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

alias tar='gtar'
alias grep="grep --color=auto"
alias egrep="egrep --color=auto"
alias rgrep="rgrep --color=auto"

alias ls="ls ${colorflag}"
alias la="ls -A"
alias lo="stat ${statoptions}"
alias l="ls -AlhFG"

alias dc=docker
alias dcp=docker-compose
alias ghcl=github_clone_organization
alias dclcnt="docker ps --no-trunc -aq | xargs docker rm"
alias dclimg="docker images -q --filter dangling=true | xargs docker rmi"
alias cask="brew cask"

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
alias fzf='fzf-tmux -d 40 --bind ctrl-f:preview-page-down,ctrl-b:preview-page-up,ctrl-r:toggle-all'
alias ff='FZF_FS_OPENER=vim . fzf-fs'

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

    if is_in_git_repo; then
        IFS=$'\n' files=($(git ls-files . -co --exclude-standard | fzf-tmux --query "$1" --multi --select-1 --exit-0))
    else
        IFS=$'\n' files=($(ag -l --nocolor -f --nogroup --hidden -g "" | fzf-tmux --query "$1" --multi --select-1 --exit-0))
    fi

    [[ -n "$files" ]] && ${EDITOR:-vim} -p "${files[@]}"
}

# Fuzzy-fasd
function ffe() {
    [ $# -gt 0 ] && fasd -f -e ${EDITOR} "$*" && return

    local files
    files="$(fasd -Rfl "$1" | fzf-tmux --query "$1" --multi)"
    [[ -n "$files" ]] && ${EDITOR:-vim} -p "${files[@]}"
}

# Modified version where you can press
#   - CTRL-O to open with `open` command,
#   - CTRL-E or Enter key to open with the $EDITOR
function fo() {
    local out file key
    IFS=$'\n' out=($(fzf-tmux --query="$1" --multi --exit-0 --expect=ctrl-o,ctrl-e))
    key=${out[0]}
    file=${out[1]}
    if [ -n "$file" ]; then
        [ "$key" = ctrl-o ] && open "$file" || ${EDITOR:-vim} -p "$file"
    fi
}

function fse() {
    local files

    [[ -n $1 ]] || return

    if is_in_git_repo; then
        IFS=$'\n' files=(
            $(
                git grep -il "$1" |
                fzf-tmux --multi --select-1 --exit-0 --preview "git grep -ih -C 10 --color=always $1 {}"
            )
        )
    else
        IFS=$'\n' files=($(ag -l --nocolor -f --nogroup --hidden "$1" | fzf-tmux --multi --select-1 --exit-0))
    fi

    [[ -n "$files" ]] && ${EDITOR:-vim} -p "${files[@]}"
}

fmd() {
    is_in_git_repo || return
    local files
    # IFS=$'\n' files=(
    #     $({ echo "$(git diff --cached --name-only)" ; echo "$(git ls-files --modified --others --exclude-standard)" ; } |
    #     awk NF | sort -u |
    #     fzf-tmux --multi --exit-0 --preview "bat {}")
    # )

    IFS=$'\n' files=(
        $(
            git -c color.status=always status -s --short |
                fzf-tmux -m --ansi --nth 2..,.. \
                --preview "bat --theme=OneHalfDark --style=numbers,changes --color=always {-1}" |
                cut -c4- | sed 's/.* -> //'
        )
    )
    [[ -n "$files" ]] && vim -p "${files[@]}"
}

fml() {
    is_in_git_repo || return
    local files
    IFS=$'\n' files=(
        $(
            echo "$(git diff-tree --no-commit-id --name-only -r HEAD)" |
            awk NF | sort -u |
            fzf-tmux --multi --exit-0 --preview "git diff --color HEAD~1 {}"
        )
    )
    [[ -n "$files" ]] && vim -p "${files[@]}"
}

fmb() {
    is_in_git_repo || return
    local files
    local branch=${1:-dev}
    IFS=$'\n' files=(
        $(
            echo "$(git diff --name-only $branch...HEAD)" |
            awk NF | sort -u |
            fzf-tmux --multi --exit-0 --preview "bat {}"
        )
    )
    [[ -n "$files" ]] && vim -p "${files[@]}"
}

fad() {
    is_in_git_repo || return
    local files target

    IFS=$'\n' files=(
        $(
            { echo "$(git ls-files --modified --others --exclude-standard)" ; } |
            awk NF | sort -u |
            fzf-tmux --multi --exit-0 --preview "bat {}"
        )
    )
    [[ -n "$files" ]] && git add "${files[@]}"
}

frm() {
    is_in_git_repo || return
    local files target

    IFS=$'\n' files=(
        $(
            git -c color.status=always status -s --short |
                fzf-tmux -m --ansi --nth 2..,.. \
                --preview "bat --theme=OneHalfDark --style=numbers,changes --color=always {-1}" |
                cut -c4- | sed 's/.* -> //'
        )
    )
    [[ -n "$files" ]] && git rm "${files[@]}"
}

fci() {
    is_in_git_repo || return
    local files target

    IFS=$'\n' files=(
        $(
            { echo "$(git ls-files --modified --others --exclude-standard)" ; } |
            awk NF | sort -u |
            fzf-tmux --multi --exit-0 --preview "bat {}"
        )
    )
    [[ -n "$files" ]] && git add "${files[@]}" && git commit
}

fll() {
    HASHZ="@"
    IFS=$'\n' FILES=(
        $(
            git show --pretty='format:' --name-status --color=always $HASHZ |
            fzf-tmux -d50 --multi --exit-0 --preview-window right:70% --preview "git diff $HASHZ $HASHZ^ {-1} | bat -ldiff" |
            cut -c3- | awk '{$1=$1};1'
        )
    )

    [[ -n "$FILES" ]] && ${EDITOR:-vim} -p "${FILES[@]}"
}

fcf() {
    is_in_git_repo || return
    local files target

    IFS=$'\n' files=(
        $(
            { echo "$(git ls-files --modified --others --exclude-standard)" ; } |
            awk NF | sort -u |
            fzf-tmux --multi --exit-0 --preview "git diff --color HEAD {}"
        )
    )
    [[ -n "$files" ]] && git checkout -- "${files[@]}"
}

frs() {
    is_in_git_repo || return
    local files target

    IFS=$'\n' files=($({ echo "$(git diff --cached --name-only)" ; } | fzf-tmux --multi --query="$1" --select-1 --exit-0))
    [[ -n "$files" ]] && git reset HEAD "${files[@]}"
}

frshd() {
    is_in_git_repo || return
    local files target

    IFS=$'\n' files=($({ echo "$(git diff --cached --name-only)" ; } | fzf-tmux --multi --query="$1" --select-1 --exit-0))
    [[ -n "$files" ]] && git reset --hard HEAD "${files[@]}"
}

fbr() {
    is_in_git_repo || return
    BRANCH=$(
        git branch -a --color=always | grep -v '/HEAD\s' | sort |
            fzf-tmux --ansi --multi --tac --preview-window right:70% \
            --preview 'git l --color=always $(sed s/^..// <<< {} | cut -d" " -f1) | head -'$LINES |
            sed 's/^..//' | cut -d' ' -f1 |
            sed 's#^remotes/##'
    ) || return

    [[ ! -z "$BRANCH" ]] && fmci $BRANCH
}

fgt() {
    is_in_git_repo || return
    git tag --sort -version:refname |
        fzf-tmux --multi --preview-window right:70% \
        --preview 'git show --patch-with-stat --color=always {} | head -'$LINES
}

fgh() {
    is_in_git_repo || return
    git log --date=short --format="%C(green)%C(bold)%cd %C(auto)%h%d %s (%an)" --graph --color=always |
        fzf-tmux --ansi --no-sort --reverse --multi --bind 'ctrl-s:toggle-sort' \
        --header 'Press CTRL-S to toggle sort' \
        --preview 'grep -o "[a-f0-9]\{7,\}" <<< {} | xargs git show --patch-with-stat --color=always | head -'$LINES |
        grep -o "[a-f0-9]\{7,\}"
}

frmt() {
    is_in_git_repo || return
    git remote -v | awk '{print $1 "\t" $2}' | uniq |
        fzf-tmux --tac --preview-window=right:65% \
        --preview 'git log --color=always --oneline --graph --date=short --pretty="format:%C(auto)%cd %h%d %s" --remotes={1} | head -500' |
        cut -d$'\t' -f1
}

fct() {
    is_in_git_repo || return
    local tags target

    tags=$(git tag | awk '{print "\x1b[31;1mtag\x1b[m\t" $1}') || return
    target=$(
        echo "$tags" |
        fzf-tmux -d30 -- --no-hscroll --ansi +m -d "\t" -n 2
    ) || return

    git checkout $(echo "$target" | awk '{print $2}')
}

fco() {
    is_in_git_repo || return
    local branches target

    branches=$(
        git branch --all | grep -v HEAD             |
        sed "s/.* //"    | sed "s#remotes/[^/]*/##" |
        sort -u          | awk '{print "\x1b[34;1mbranch\x1b[m\t" $1}'
    ) || return
    target=$(
        echo "$branches" |
        fzf-tmux -d30 --query="$1" --select-1 -- --no-hscroll --ansi +m -d "\t" -n 2
    ) || return

    git checkout $(echo "$target" | awk '{print $2}')
}

fme() {
    is_in_git_repo || return
    local branches target

    branches=$(
        git branch --all |
        grep -v HEAD |
        sed "s/.* //" |
        sed "s#remotes/[^/]*/##" |
        sort -u |
        awk '{print "\x1b[34;1mbranch\x1b[m\t" $1}'
    ) || return

    target=$(
        echo "$branches" |
        fzf-tmux -d30 --query="$1" -- --no-hscroll --ansi +m -d "\t" -n 2
    ) || return

    git merge --no-ff --no-edit $(echo "$target" | awk '{print $2}')
}

frbi() {
    is_in_git_repo || return
    REBASESTRING=$(git log --oneline --decorate --graph --color=always | head -n 30 | fzf-tmux --ansi --reverse)

    HASH="$(echo ${REBASESTRING} | awk '{ print $2 }')"
    [[ ! -z "$HASH" ]] && git rebase -i "$(echo ${HASH} | awk '{ print $1 }')^"
}

fref() {
    is_in_git_repo || return
    HASH=$(git reflog --color=always | head -n 100 | fzf-tmux --ansi --reverse --query="$1" --exit-0) || return
    HASHZ=$(echo ${HASH} | awk '{ print $1 }') || return

    [[ ! -z "$HASH" ]] && git reset --hard $HASHZ
}

fmci() {
    is_in_git_repo || return
    BRANCH=${1:-@}
    HASH=$(
        git log --oneline --graph --color=always $BRANCH | head -n 100 |
            fzf-tmux --ansi --reverse --exit-0 \
            --preview='grep -o "[a-f0-9]\{7,\}" <<< {} | xargs git show --patch-with-stat --color=always'
        ) || return
    HASHZ=$(echo ${HASH} | grep -o "[a-f0-9]\{7,\}") || return
    IFS=$'\n' FILES=(
        $(
            git show --pretty='format:' --name-status --color=always $HASHZ |
            fzf-tmux --multi --exit-0 --preview "git diff $HASHZ $HASHZ^ {-1} | bat -ldiff --theme=OneHalfDark --style=numbers,changes --color=always" |
            cut -c3- | awk '{$1=$1};1'
        )
    )

    [[ -n "$FILES" ]] && ${EDITOR:-vim} -p "${FILES[@]}"
}

# NOT WORKING
fsh() {
    is_in_git_repo || return
    local out k reflog

    out=(
        $(git stash list --pretty='%C(yellow)%gd %>(14)%Cgreen%cr %C(blue)%gs' |
            fzf --ansi --no-sort --header='enter:show, ctrl-d:diff, ctrl-o:pop, ctrl-y:apply, ctrl-x:drop' \
            --preview='git stash show --color=always -p $(cut -d" " -f1 <<< {}) | head -'$LINES \
            --preview-window=down:50% --reverse \
            --bind='enter:execute(git stash show --color=always -p $(cut -d" " -f1 <<< {}) | less -r > /dev/tty)' \
            --bind='ctrl-d:execute(git diff --color=always $(cut -d" " -f1 <<< {}) | less -r > /dev/tty)' \
            --expect=ctrl-o,ctrl-y,ctrl-x)
    )
    k=${out[0]}
    reflog=${out[1]}

    [ -n "$reflog" ] && case "$k" in
    ctrl-o) git stash pop $reflog ;;
    ctrl-y) git stash apply $reflog ;;
    ctrl-x) git stash drop $reflog ;;
esac
}

bind '"\er": redraw-current-line'
