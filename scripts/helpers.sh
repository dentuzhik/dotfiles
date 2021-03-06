source $DOTFILES_HOME/scripts/colors.sh

function ls_completion {
    local dir_path="$1"
    COMPLETION=()

    if [[ $COMP_CWORD == 1 ]]; then
        COMPREPLY=( $(compgen -W "$(ls $dir_path)" -- "${COMP_WORDS[COMP_CWORD]}") )
        return 0
    fi
}

function github_clone_organization() {
    local org_name=$1
    local gh_host=${2-'github.com'}
    local api_path="https://api."$gh_host

    if [ ! "$org_name" ]; then
        echo 'Empty organization name.'
        return
    fi

    local repos_count=$(
        curl -s $api_path"/orgs/$org_name" |
        python -c "import sys; from json import loads; print(loads(sys.stdin.read())['public_repos'])"
    )

    echo 'There are '$(echo_red $repos_count)' public repos available in '$(echo_red $org_name)' organization.'
    read -p 'Do you really want to clone them all (y/n)? ' yn

    case $yn in
        'y')
            curl -s $api_path"/orgs/$org_name/repos" |
            python -c "from sys import stdin; from json import loads; from subprocess import call; [call(['git', 'clone', repo['clone_url']]) for repo in loads(stdin.read())] "
        ;;
        'n')
            echo 'Aborted.'
        ;;
    esac
}

export -f ls_completion
