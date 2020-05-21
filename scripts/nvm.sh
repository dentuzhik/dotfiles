# shellcheck source=/dev/null
source $DOTFILES_HOME/scripts/colors.sh

export NVM_DIR="$HOME/.nvm"

function get_current_date() {
    echo $(date +%y%m%d)
}

function get_latest_nvm_release() {
    echo $(
        curl -s -L "https://api.github.com/repositories/612230/releases/latest" |
        python -c "import sys; from json import loads; print(loads(sys.stdin.read())['tag_name'])"
    )
}

function setup_nvm() {
    if [ ! -d "$NVM_DIR" ]; then
        echo 'Installing latest version of nvm'
        install_nvm $latest_nvm_release
        echo $(get_current_date) > "$HOME/.nvmupdate"
        return
    fi

    source "$NVM_DIR/nvm.sh"
    upgrade_nvm
}

function upgrade_nvm() {
    local date_difference=$(( ($(gdate --date="$(get_current_date)" +%s) - $(gdate --date="$(cat $HOME/.nvmupdate &> /dev/null)" +%s) )/(60*60*24) ))

    # Update treshold could be easily extracted into environment variable
    if [[ $date_difference -gt 7 ]]; then
        local latest_nvm_release=$(get_latest_nvm_release)
        local current_nvm_release="v$(nvm --version)"

        if [[ ! $current_nvm_release == $latest_nvm_release ]]; then
            echo "Update is available for nvm. Current version: $(echo_red $current_nvm_release). Available version: $(echo_red $latest_nvm_release)"
            read -p 'Do you want to install it (y/n)? ' yn

            case $yn in
                'y')
                    echo 'Updating nvm to the latest version'
                    install_nvm $latest_nvm_release
                ;;
                'n')
                    # Remember the choice
                    echo $(get_current_date) > "$HOME/.nvmupdate"
                    return
                ;;
            esac
        fi
    fi
}

function install_nvm() {
    local release=${1-$(get_latest_nvm_release)}

    mkdir ~/.nvm
    curl -o- "https://raw.githubusercontent.com/creationix/nvm/$release/install.sh" | bash
    source "$NVM_DIR/nvm.sh"

    # Postinstall steps
    echo $(get_current_date) > "$HOME/.nvmupdate"

    # Clear all the mess
    clear
}

setup_nvm
