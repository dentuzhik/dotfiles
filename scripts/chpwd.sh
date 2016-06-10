function chpwd() {
    if [[ -f $PWD/.nvmrc && -r $PWD/.nvmrc ]]; then
        nvm use
    elif [[ $(nvm version) != $(nvm version default)  ]]; then
        nvm use default
    fi
}
