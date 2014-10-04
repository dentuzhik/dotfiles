function red() {
    echo "\[\e[1;31m\]$1\[\e[0;39m\]"
}

function yellow() {
    echo "\[\e[1;33m\]$1\[\e[0;39m\]"
}

function blue() {
    echo "\[\e[1;34m\]$1\[\e[0;39m\]"
}

function cyan() {
    echo "\[\e[1;36m\]$1\[\e[0;39m\]"
}

function magenta() {
    echo "\[\e[1;35m\]$1\[\e[0;39m\]"
}

function github_clone_organization() {
    local org_name=$1
    local gh_host=${2-'github.com'}
    local api_path="https://api."$gh_host

    if [ ! "$org_name" ]; then
        echo 'Empty organization name.'
        return
    fi

    local public_repos_count=`
        curl -s $api_path"/orgs/$org_name" |
        python -c "import sys; from json import loads; print(loads(sys.stdin.read())['public_repos'])"
    `

    echo -e 'There are '`red $public_repos_count`' public repos available in '`red $org_name`' organization.'
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
