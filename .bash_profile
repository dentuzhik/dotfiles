export PATH=/usr/local/bin:$PATH

# Load the default .profile
[[ -s "$HOME/.profile" ]] && source "$HOME/.profile"
[[ -s "$HOME/.bashrc" ]] && source "$HOME/.bashrc"
# Load RVM into a shell session *as a function*
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
eval "$(docker-machine env default)"
[ -s "/Users/dentuzhik/work/testlio-toolbox/testlio.sh" ] && source "/Users/dentuzhik/work/testlio-toolbox/testlio.sh"
