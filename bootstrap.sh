# Basic symlinking
function link {
    local base_dir=$1
    local entries=$2
    local is_overwritten=$3

    for entry_name in $entries; do
        ln -fs $base_dir/$entry_name $HOME/$entry_name
        if [ ! $is_overwritten ]; then
            echo 'Linked '$entry_name'.'
        else
            echo 'Linked ovewritten '$entry_name'.'
        fi
    done

    echo 'Done.'
}

: ${base_dir:=$HOME/dotfiles}
: ${entries:='.bashrc .bash_aliases .vim .vimrc .ssh/config .tmux.conf .gitconfig .editorconfig'}

echo 'This script may overwrite some files in your $HOME'

read -p 'Do you want to continue (y/n)? ' yn;
case $yn in
    'y')
        link $base_dir "$entries"
    ;;
    'n')
        echo 'Aborted.'
    ;;
esac
