#!/usr/bin/env bash

set -Eeuo pipefail

DOTFILES_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
readonly DOTFILES_DIR
readonly ENTRIES=(
    .bash_profile
    .bashrc
    .bash_aliases
    .ssh/config
    .config/karabiner
    .config/nvim
    .tmux.conf
    .gitconfig
    .gitignore
    .editorconfig
    .finicky.js
)

link_dotfiles() {
    local backup_dir backup_parent source target entry
    backup_dir="$HOME/.dotfiles-backups/$(date +%Y%m%d-%H%M%S)"
    install -d -m 700 "$HOME/.dotfiles-backups" "$backup_dir"

    for entry in "${ENTRIES[@]}"; do
        source="$DOTFILES_DIR/$entry"
        target="$HOME/$entry"

        if [[ ! -e "$source" ]]; then
            printf 'Missing source: %s\n' "$source" >&2
            return 1
        fi

        if [[ -L "$target" && "$(readlink "$target")" == "$source" ]]; then
            printf 'Already linked: %s\n' "$entry"
            continue
        fi

        if [[ -e "$target" || -L "$target" ]]; then
            backup_parent="$backup_dir/$(dirname -- "$entry")"
            mkdir -p "$backup_parent"
            chmod 700 "$backup_parent"
            mv "$target" "$backup_dir/$entry"
            printf 'Backed up: %s\n' "$entry"
        fi

        mkdir -p "$(dirname -- "$target")"
        ln -s "$source" "$target"
        printf 'Linked: %s\n' "$entry"
    done
}

main() {
    local answer

    printf 'Existing dotfiles will be backed up under ~/.dotfiles-backups.\n'
    read -r -p 'Continue? [y/N] ' answer
    [[ "$answer" =~ ^[Yy]$ ]] || {
        printf 'Aborted.\n'
        return
    }

    touch "$HOME/.hushlogin"
    git -C "$DOTFILES_DIR" submodule update --init --recursive
    link_dotfiles

    printf 'Done. Restart the terminal to load the updated configuration.\n'
}

main "$@"
