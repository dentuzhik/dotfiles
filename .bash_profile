# shellcheck shell=bash

[[ -r $HOME/.profile ]] && source "$HOME/.profile"
[[ -r $HOME/.bashrc ]] && source "$HOME/.bashrc"

if [[ -r $HOME/.iterm2_shell_integration.bash ]]; then
    source "$HOME/.iterm2_shell_integration.bash"
fi
