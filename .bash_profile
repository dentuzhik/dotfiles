export PATH=/usr/local/bin:$PATH

# Load the default .profile
[[ -s "~/.profile" ]] && source "~/.profile"
[[ -s "$HOME/.bashrc" ]] && source "$HOME/.bashrc"
# Load RVM into a shell session *as a function*
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
