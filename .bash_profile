export PATH=/usr/local/bin:$PATH

# Load the default .profile
[[ -s "$HOME/.profile" ]] && source "$HOME/.profile"
[[ -s "$HOME/.bashrc" ]] && source "$HOME/.bashrc"
# Load RVM into a shell session *as a function*
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"

source "$HOME/.1p-session"
