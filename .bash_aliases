# shellcheck shell=bash

SHELL_CONFIG_DIR="$HOME/.config/shell"
if [[ ! -r $SHELL_CONFIG_DIR/aliases.sh ]]; then
    SHELL_CONFIG_DIR="$HOME/dotfiles/.config/shell"
fi
[[ -r $SHELL_CONFIG_DIR/aliases.sh ]] && source "$SHELL_CONFIG_DIR/aliases.sh"
unset SHELL_CONFIG_DIR
