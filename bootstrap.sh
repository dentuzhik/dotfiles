# Basic symlinking
function link {
    : ${base_dir:=$HOME/dotfiles}
    : ${entries:='.vim .vimrc .tmux.conf .gitconfig .bash_aliases .editorconfig'}

    for entry_name in $entries; do
        ln -fs $base_dir/$entry_name $HOME/$entry_name
        echo 'Linked '$entry_name'.'
    done

    echo 'Done.'
}

echo 'This script may overwrite some files in your $HOME';
echo 'Do you want to continue [y/n]?'

read yn;
case $yn in
    'y')
        link
    ;;
    'n')
        echo 'Aborted.'
    ;;
esac
