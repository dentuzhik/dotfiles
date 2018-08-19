download_tmux_plugin_manager() {
    if [ ! -d ~/.tmux/plugins/tpm ]; then
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    fi
}

curl_git_scripts() {
    local target_dir=$1
    local git_completion_url='https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash'
    local git_prompt_url='https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh'
    local git_prompt_file=$target_dir/.git-prompt.sh
    local git_completion_file=$target_dir/.git-completion.bash

    if [ ! -f "$git_prompt_file" ]; then
        echo "Loading $git_prompt_file"
        curl -so "$git_prompt_file" $git_prompt_url
    fi

    if [ ! -f "$git_completion_file" ]; then
        echo "Loading $git_completion_file"
        curl -so "$git_completion_file" $git_completion_url
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
: ${entries:='.bash_profile .bashrc .bash_aliases .vimrc .ssh/config .config/karabiner .tmux.conf .gitconfig .gitignore .editorconfig .mongorc.js'}

echo 'This script may overwrite some files in your $HOME'
read -p 'Do you want to continue (y/n)? ' yn
case $yn in
    'y')
        touch ~/.hushlogin
        chsh -s /usr/local/bin/bash
        echo $BASH_VERSION

        curl_git_scripts ~
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
