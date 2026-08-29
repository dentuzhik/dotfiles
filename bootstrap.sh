download_tmux_plugin_manager() {
    if [ ! -d ~/.tmux/plugins/tpm ]; then
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    fi
}

# Basic symlinking
link() {
    local base_dir=$1
    local entries=$2
    local is_overwritten=$3

    for entry_name in $entries; do
        ln -fFns "$base_dir/$entry_name" ~/"$entry_name"
        if [ ! "$is_overwritten" ]; then
            echo "Linked $entry_name."
        else
            echo "Linked ovewritten $entry_name."
        fi
    done
}

: ${dotfiles_dir:=~/dotfiles}
: ${base_dir:=~/dotfiles}
: ${entries:='.bash_profile .bashrc .bash_aliases .vimrc .ssh/config .config/karabiner .tmux.conf .gitconfig .gitignore .editorconfig .mongorc.js .finicky.js'}

echo 'This script may overwrite some files in your $HOME'
read -p 'Do you want to continue (y/n)? ' yn
case $yn in
    'y')
        touch ~/.hushlogin
        chsh -s /opt/homebrew/bin/bash
        echo $BASH_VERSION

        download_tmux_plugin_manager
        link $base_dir "$entries"

        # Set up Neovim
        mkdir -p ~/.config/nvim
        ln -fFns "$base_dir/.nvim/init.vim" ~/.config/nvim/init.vim
        ln -fFns "$base_dir/.nvim/UltiSnips" ~/.config/nvim/UltiSnips

        echo 'Linked Neovim configuration'
        echo 'Done!'
    ;;
    'n')
        echo 'Aborted.'
    ;;
esac
