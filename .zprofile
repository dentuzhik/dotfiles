# Login environment for Zsh. Interactive behavior belongs in .zshrc.

SHELL_CONFIG_DIR="$HOME/.config/shell"
if [[ ! -r $SHELL_CONFIG_DIR/env.sh ]]; then
    SHELL_CONFIG_DIR="${DOTFILES_HOME:-$HOME/dotfiles}/.config/shell"
fi
[[ -r $SHELL_CONFIG_DIR/env.sh ]] && source "$SHELL_CONFIG_DIR/env.sh"
unset SHELL_CONFIG_DIR
