# Load the default .profile
[[ -s "~/.profile" ]] && source "~/.profile"

export PATH=/usr/local/bin:$PATH

if [ -f $(brew --prefix)/etc/bash_completion ]; then
    source $(brew --prefix)/etc/bash_completion
fi

[[ -s "$HOME/.bashrc" ]] && source "$HOME/.bashrc"

# Load RVM into a shell session *as a function*
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
