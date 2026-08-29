# shellcheck shell=bash

# Keep non-interactive shells quiet and fast.
case $- in
    *i*) ;;
    *) return ;;
esac

export LANG="en_US.UTF-8"
export LC_CTYPE="$LANG"
export EDITOR="nvim"
export VISUAL="$EDITOR"
export DOTFILES_HOME="${DOTFILES_HOME:-$HOME/dotfiles}"

path_prepend() {
    [[ -d $1 ]] || return
    case ":$PATH:" in
        *":$1:"*) ;;
        *) PATH="$1:$PATH" ;;
    esac
}

path_append() {
    [[ -d $1 ]] || return
    case ":$PATH:" in
        *":$1:"*) ;;
        *) PATH="$PATH:$1" ;;
    esac
}

# Use a known Homebrew installation instead of resolving a user-controlled PATH.
BREW_BIN=""
for candidate in /opt/homebrew/bin/brew /usr/local/bin/brew /home/linuxbrew/.linuxbrew/bin/brew; do
    if [[ -x $candidate ]]; then
        BREW_BIN=$candidate
        break
    fi
done

if [[ -n $BREW_BIN ]]; then
    eval "$("$BREW_BIN" shellenv)"
    BREW_PREFIX=$("$BREW_BIN" --prefix)

    if [[ -r $BREW_PREFIX/etc/profile.d/bash_completion.sh ]]; then
        source "$BREW_PREFIX/etc/profile.d/bash_completion.sh"
    elif [[ -r /etc/bash_completion ]]; then
        source /etc/bash_completion
    fi

    GIT_PREFIX=$("$BREW_BIN" --prefix git 2>/dev/null || true)
    if [[ -n $GIT_PREFIX ]]; then
        [[ -r $GIT_PREFIX/etc/bash_completion.d/git-completion.bash ]] &&
            source "$GIT_PREFIX/etc/bash_completion.d/git-completion.bash"
        [[ -r $GIT_PREFIX/etc/bash_completion.d/git-prompt.sh ]] &&
            source "$GIT_PREFIX/etc/bash_completion.d/git-prompt.sh"
        path_append "$GIT_PREFIX/share/git-core/contrib/diff-highlight"
    fi
fi

path_prepend "$HOME/.fastlane/bin"
path_prepend "$HOME/.rbenv/shims"
path_prepend "$HOME/.codeium/windsurf/bin"
path_prepend "$HOME/.rover/bin"
path_prepend "$HOME/Library/pnpm"
path_prepend "$HOME/.bun/bin"
path_prepend "$HOME/.local/bin"
path_prepend /usr/local/sbin
export PATH

unset -f path_prepend path_append
unset candidate BREW_BIN BREW_PREFIX GIT_PREFIX

if [[ -r $HOME/.bash_aliases ]]; then
    source "$HOME/.bash_aliases"
fi

HISTCONTROL=ignoreboth:erasedups
HISTSIZE=10000
HISTFILESIZE=20000
shopt -s histappend checkwinsize extglob
shopt -s autocd cdspell dirspell globstar 2>/dev/null || true

if [[ -x /usr/bin/lesspipe ]]; then
    eval "$(SHELL=/bin/sh /usr/bin/lesspipe)"
fi

if declare -F __git_ps1 >/dev/null; then
    export GIT_PS1_SHOWDIRTYSTATE=1
    export GIT_PS1_SHOWUPSTREAM="verbose"
    PS1='\[\e[1;34m\][\t]\[\e[0m\] \W$(__git_ps1 " (%s)") \[\e[1;31m\]→\[\e[0m\] '
else
    PS1='\[\e[1;34m\][\t]\[\e[0m\] \W \[\e[1;31m\]→\[\e[0m\] '
fi

if command -v fnm >/dev/null 2>&1; then
    eval "$(fnm env --use-on-cd --version-file-strategy=recursive --shell bash)"
fi

if command -v pyenv >/dev/null 2>&1; then
    eval "$(pyenv init - bash)"
fi

if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init bash)"
fi

if command -v fzf >/dev/null 2>&1; then
    export FZF_CTRL_R_OPTS="
      --preview 'echo {}' --preview-window up:3:hidden:wrap
      --bind 'ctrl-/:toggle-preview'
      --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
      --color header:italic
      --header 'Press CTRL-Y to copy command into clipboard'"
    eval "$(command fzf --bash)"
fi

if command -v thefuck >/dev/null 2>&1; then
    eval "$(thefuck --alias)"
fi

if command -v saml2aws >/dev/null 2>&1; then
    eval "$(saml2aws --completion-script-bash)"
fi

if [[ -r $HOME/.config/op/plugins.sh ]]; then
    source "$HOME/.config/op/plugins.sh"
fi

if command -v direnv >/dev/null 2>&1; then
    eval "$(direnv hook bash)"
fi

if [[ -z $TMUX && -n $SSH_TTY ]] && command -v tmux >/dev/null 2>&1; then
    tmux attach || tmux new
fi
