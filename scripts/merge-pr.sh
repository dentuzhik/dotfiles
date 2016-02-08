# Merges pull request of provided branch via Github API v3
function merge_pr {
    # Getting function options
    local OPTIND
    getopts "y" opt

    # For usage with more than one option, this should be replaced with loop
    local PERMIT=
    if [[ $opt == 'y' ]]; then
        PERMIT=1
    fi
    shift $((OPTIND-1))

    local branch_name=$1

    # Prompt if usage of current branch to find pull request is allowed
    if [[ -z $branch_name ]]; then
        branch_name=$(git rev-parse --abbrev-ref HEAD)
    fi

    local github_api_url='https://api.github.yandex-team.ru'
    local origin_path='/repos/'$(git ls-remote --get-url origin | awk '{ gsub(/(https:\/\/|git@)github\.yandex-team\.ru(\/|:)/, ""); gsub(/\.git/, ""); print }')

    local repo_info_str=$(
        curl -s $github_api_url$origin_path |
        python -c "import sys; from json import loads; res = loads(sys.stdin.read()); print(res['fork']); print(res['parent']['full_name']) if 'parent' in res else ''"
    )
    local repo_info=()

    IFS=$'\n'
    for field in $repo_info_str; do
        repo_info+=("$field")
    done
    unset $IFS

    local is_repo_fork=
    [[ ${repo_info[0]} == 'True' ]] && is_repo_fork=1 || is_repo_fork=0

    local upstream_path=
    if [[ $is_repo_fork == 1 ]]; then
        upstream_path='/repos/'${repo_info[1]}
    else
        upstream_path=$origin_path
    fi

    local origin_org_name=$(echo $origin_path | cut -d '/' -f 3)
    local pr_path="/pulls?head=$origin_org_name:$branch_name"

    local get_matching_pr_url=$github_api_url$upstream_path$pr_path
    local pr_number=$(
        curl -s $get_matching_pr_url |
        python -c "import sys; from json import loads; res = loads(sys.stdin.read()); print(res[0]['number'] if len(res) > 0 else '')"
    )

    # If no pull request was found and repo is a fork, try to find pull request inside a fork
    if [[ -z $pr_number && $is_repo_fork == 1 ]]; then
        get_matching_pr_url=$github_api_url$origin_path$pr_path
        pr_number=$(
            curl -s $get_matching_pr_url |
            python -c "import sys; from json import loads; res = loads(sys.stdin.read()); print(res[0]['number'] if len(res) > 0 else '')"
        )

        # If pull request was found inside a fork, change upstream_path
        if [[ -n $pr_number ]]; then
            upstream_path=$origin_path
        fi
    fi

    # Exit if no pull request was found
    if [[ -z $pr_number ]]; then
        echo 'No opened pull request was found for branch '$(echo_red $branch_name)
        echo
        return
    fi

    local get_pr_info_url=$github_api_url$upstream_path'/pulls/'$pr_number
    local pr_info_str=$(
        curl -s $get_pr_info_url |
        python -c "import sys; from json import loads; res = loads(sys.stdin.read()); print(res['html_url']); print(res['state']); print(res['title'].encode('utf-8')); print(res['commits']); print(res['user']['login']);"
    )
    local pr_info=()

    IFS=$'\n'
    for field in $pr_info_str; do
        pr_info+=("$field")
    done
    unset $IFS

    local pr_url=${pr_info[0]}
    local pr_state=${pr_info[1]}
    local pr_title=${pr_info[2]}
    local pr_commits=${pr_info[3]}
    local pr_user=${pr_info[4]}

    local jira_issue_name=$(echo $pr_title | egrep -o '^SERP-[0-9]{5}')

    if [[ -z $jira_issue_name ]]; then
        echo 'Pull request title should start with JIRA task number!'
        # echo 'No task number provided for this pull rquest, or task number is (most likely) invalid.'
        echo_red $pr_url
        echo
        return
    fi

    if [[ $PERMIT -ne 1 ]]; then
        echo
        echo $(echo_red 'Title      ')$pr_title
        echo $(echo_red 'URL        ')$pr_url
        echo $(echo_red 'User       ')$pr_user
        echo $(echo_red 'Commits    ')$pr_commits
        echo $(echo_red 'JIRA       ')'https://jira.yandex-team.ru/browse/'$jira_issue_name
        echo

        read -p 'Do you really want to merge this pull request '$(echo_red '(y/n)')'? ' yn
        if [[ $yn != 'y' ]]; then
            echo 'Aborted.'
            echo
            return
        fi
    fi

    local github_api_token=''
    local github_api_token_file=~/.oauth/github_yandex_team.token

    # Use existing Github API OAuth token, if available
    # If not, generate a new one
    if [[ -f $github_api_token_file ]]; then
        github_api_token=$(cat $github_api_token_file)
    else
        echo
        echo 'No Github API OAuth token found, will generate now.'

        local api_scopes='[ "repo", "public_repo", "repo:status", "delete_repo", "gist" ]'
        github_api_token=$(
            curl -s -u $pr_user -X 'POST' -d '{ "scopes": '$api_scopes', "note": "Scripts on '"$(whoami)@$(uname -n)"'" }' $github_api_url'/authorizations' |
            python -c "import sys; from json import loads; res = loads(sys.stdin.read()); print(res['token'])"
        )

        if [[ -n $github_api_token ]]; then
            mkdir -p ~/.oauth
            echo $github_api_token > $github_api_token_file
            echo 'New Github OAuth token successfully generated: '$github_api_token
        fi
    fi

    local merge_pr_url=$github_api_url$upstream_path'/pulls/'$pr_number'/merge'
    # TODO: Fix single and double quotes escaping
    local merge_res_code=$(curl -s -o /dev/null -w "%{http_code}" -X 'PUT' -H "Authorization: token $github_api_token"  -d '{ "commit_message": "'$pr_title'" }' $merge_pr_url)

    echo

    if [[ $merge_res_code == '200' ]]; then
        echo "Pull request #$pr_number from $origin_org_name/$branch_name was successfully merged."
        echo

        local remote='origin'
        local delete_res_code=$(curl -s -o /dev/null -w "%{http_code}" -X 'DELETE' -H "Authorization: token $github_api_token" $github_api_url$origin_path"/git/refs/heads/$branch_name")

        if [[ $delete_res_code == '204' ]]; then
            echo "Successfully deleted $(echo_red $remote/$branch_name) branch."
            echo

            git remote prune $remote
            echo
        fi
    elif [[ $merge_res_code == '405' ]]; then
        echo "Pull request #$pr_number can't be merged."
        echo
    fi
}
