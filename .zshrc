# Interactive Zsh configuration.

[[ -o interactive ]] || return

SHELL_CONFIG_DIR="$HOME/.config/shell"
if [[ ! -r $SHELL_CONFIG_DIR/env.sh ]]; then
    SHELL_CONFIG_DIR="${DOTFILES_HOME:-$HOME/dotfiles}/.config/shell"
fi
if [[ -r $SHELL_CONFIG_DIR/env.sh ]]; then
    source "$SHELL_CONFIG_DIR/env.sh"
fi
if [[ -r $SHELL_CONFIG_DIR/aliases.sh ]]; then
    source "$SHELL_CONFIG_DIR/aliases.sh"
fi
unset SHELL_CONFIG_DIR

# Keep Zsh history separate from Bash history.
HISTFILE="$HOME/.zsh_history"
HISTSIZE=20000
SAVEHIST=20000
setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY
setopt INTERACTIVE_COMMENTS
setopt AUTO_CD

# Use only completion directories accepted by Zsh's ownership and permission audit.
ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
if [[ ! -d $ZSH_CACHE_DIR ]]; then
    command mkdir -p -- "$ZSH_CACHE_DIR"
    command chmod 700 "$ZSH_CACHE_DIR"
fi

autoload -Uz compinit compaudit
typeset -a insecure_completion_paths
insecure_completion_paths=(${(f)"$(compaudit 2>/dev/null)"})
if (( ${#insecure_completion_paths[@]} == 0 )); then
    compinit -d "$ZSH_CACHE_DIR/zcompdump"
else
    # Keep completion enabled, but exclude every path rejected by compaudit.
    compinit -i -d "$ZSH_CACHE_DIR/zcompdump"
fi
unset insecure_completion_paths

# Native Git-aware prompt without a plugin framework.
autoload -Uz add-zsh-hook vcs_info
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr '+'
zstyle ':vcs_info:git:*' unstagedstr '*'
zstyle ':vcs_info:git:*' formats ' (%b%c%u)'
_dotfiles_update_vcs_info() {
    vcs_info
}
add-zsh-hook precmd _dotfiles_update_vcs_info
setopt PROMPT_SUBST
PROMPT='%F{blue}[%*]%f %1~${vcs_info_msg_0_} %F{red}→%f '

if command -v fnm >/dev/null 2>&1; then
    eval "$(fnm env --use-on-cd --version-file-strategy=recursive --shell zsh)"
fi

if command -v pyenv >/dev/null 2>&1; then
    eval "$(pyenv init - zsh)"
fi

if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init zsh)"
fi

if command -v fzf >/dev/null 2>&1; then
    export FZF_CTRL_R_OPTS="
      --preview 'echo {}' --preview-window up:3:hidden:wrap
      --bind 'ctrl-/:toggle-preview'
      --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
      --color header:italic
      --header 'Press CTRL-Y to copy command into clipboard'"
    source <(command fzf --zsh)
fi

if command -v thefuck >/dev/null 2>&1; then
    eval "$(thefuck --alias)"
fi

if command -v saml2aws >/dev/null 2>&1; then
    eval "$(saml2aws --completion-script-zsh)"
fi

if [[ -r $HOME/.config/op/plugins.sh ]]; then
    source "$HOME/.config/op/plugins.sh"
fi

if command -v direnv >/dev/null 2>&1; then
    eval "$(direnv hook zsh)"
fi

if [[ -r $HOME/.iterm2_shell_integration.zsh ]]; then
    source "$HOME/.iterm2_shell_integration.zsh"
fi

if [[ -z $TMUX && -n $SSH_TTY ]] && command -v tmux >/dev/null 2>&1; then
    tmux attach || tmux new
fi
