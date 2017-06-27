function chpwd() {
    if [[ -f $PWD/.nvmrc && -r $PWD/.nvmrc ]]; then
        nvm use
        local nvm_error=$(nvm use 2>&1 > /dev/null)
        if [[ ! -z $nvm_error ]]; then
            # Extracting missing version from error string
            local missing_version=$(expr "$nvm_error" : ".*\(v[0-9]\(\.[0-9]\)\{1,2\}\)")
            read -p "Do you want install version $missing_version (y/n)? " yn

            case $yn in
                'y')
                    nvm install $missing_version
                    ;;
                'n')
                    return
                    ;;
            esac
        fi
    elif [[ $(nvm version) != $(nvm version default)  ]]; then
        nvm use default
    fi
}
