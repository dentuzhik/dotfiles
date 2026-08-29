# shellcheck shell=bash

# Keep non-interactive shells quiet and fast.
case $- in
    *i*) ;;
    *) return ;;
esac

SHELL_CONFIG_DIR="$HOME/.config/shell"
if [[ ! -r $SHELL_CONFIG_DIR/env.sh ]]; then
    SHELL_CONFIG_DIR="$HOME/dotfiles/.config/shell"
fi
[[ -r $SHELL_CONFIG_DIR/env.sh ]] && source "$SHELL_CONFIG_DIR/env.sh"
unset SHELL_CONFIG_DIR

if [[ -n ${HOMEBREW_PREFIX:-} ]]; then
    if [[ -r $HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh ]]; then
        source "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh"
    elif [[ -r /etc/bash_completion ]]; then
        source /etc/bash_completion
    fi

    GIT_PREFIX=$("$HOMEBREW_PREFIX/bin/brew" --prefix git 2>/dev/null || true)
    if [[ -n $GIT_PREFIX ]]; then
        [[ -r $GIT_PREFIX/etc/bash_completion.d/git-completion.bash ]] &&
            source "$GIT_PREFIX/etc/bash_completion.d/git-completion.bash"
        [[ -r $GIT_PREFIX/etc/bash_completion.d/git-prompt.sh ]] &&
            source "$GIT_PREFIX/etc/bash_completion.d/git-prompt.sh"
    fi
fi
unset GIT_PREFIX

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
