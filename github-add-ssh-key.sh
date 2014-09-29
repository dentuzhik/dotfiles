source $DOTFILES_HOME/helper_functions.sh

function setup_trap() {
    trap $1 SIGHUP SIGINT SIGQUIT SIGABRT SIGKILL SIGALRM SIGTERM
}

function ssh_generate_add() {
    local key_file=$1
    local key_title=$2
    local key_pass=$3
    local temp_pass_file=`mktemp`

    function clean_temp_pass() {
        rm -f $temp_pass_file
    }

    # Prevent anything from keeping temp password file on file system
    setup_trap 'clean_temp_pass'

    # Delete any other entry with the same name
    if [ -e "$key_file" ]; then
        ssh-add -d $key_file
    fi

    # Generate new private/public pair of keys
    ssh-keygen -t rsa -C $key_title -N $key_pass -f $key_file

    # Create temp file with password to use ssh-add silently
    echo "echo $key_pass" > $temp_pass_file
    chmod u+x $temp_pass_file

    # Export necessary variables not to use temp password file
    [ "$DISPLAY" ] || export DISPLAY=dummydisplay:0
    export SSH_ASKPASS=$temp_pass_file

    # Add key with provided password to ssh-agent
    ssh-add $key_file < /dev/null

    # Clean things up
    clean_temp_pass
}

: ${gh_host:='github.com'}
: ${key_file_name:='github'}

api_path='/user/keys'
api_url='https://api.'$gh_host$api_path
machine_name=`whoami`'@'`uname -n`

read -p 'Enter your Github username: ' gh_username
read -s -p 'Enter your Github password: ' gh_password
echo

key_file=~/.ssh/"$key_file_name"_rsa

# Generates new private/public pair of keys and adds it to ssh-agent
ssh_generate_add $key_file $machine_name $gh_password

function clean_keys() {
    ssh-add -d $key_file
    rm -f $key_file $key_file".pub"
}

# Prevent anything from keeping unsubmitted key on file system
setup_trap 'clean_keys'

public_key=`cat $key_file".pub"`
data='{"title": "'$machine_name'", "key": "'$public_key'"}'

echo
echo -e 'The following key will be added to your Github account ('`make_red $gh_host'/'$gh_username`') for '`make_red $machine_name`':'
echo "$public_key"

read -p 'Do you want to continue (y/n)? ' yn
case $yn in
    'y')
        curl -su $gh_username:$gh_password -X POST -d "$data" $api_url
        echo 'Github key was successfully created.'
    ;;
    'n')
        clean_keys
        echo 'Aborted.'
    ;;
esac
