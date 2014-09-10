# Basic symlinking
function link {
    base_dir=$HOME/dotfiles
    files='.vimrc .tmux.conf .gitconfig .bash_aliases'

    for file_name in $files; do
        ln -fs $base_dir/$file_name $HOME/$file_name
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

