# Fig pre block. Keep at the top of this file.
[[ -f "$HOME/.fig/shell/bash_profile.pre.bash" ]] && builtin source "$HOME/.fig/shell/bash_profile.pre.bash"

export PATH=/usr/local/bin:$PATH

# Load the default .profile
[[ -s "$HOME/.profile" ]] && source "$HOME/.profile"
[[ -s "$HOME/.bashrc" ]] && source "$HOME/.bashrc"

test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"

export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools

export PATH="$HOME/.fastlane/bin:$PATH"
export PATH="$HOME/.rbenv/shims:$PATH"

# Fig post block. Keep at the bottom of this file.
[[ -f "$HOME/.fig/shell/bash_profile.post.bash" ]] && builtin source "$HOME/.fig/shell/bash_profile.post.bash"

export PKG_CONFIG_PATH="/opt/homebrew/opt/pixman/lib/pkgconfig"

# https://github.com/Versent/saml2aws?tab=readme-ov-file#bash
if command -v saml2aws > /dev/null 2>&1; then
    eval "$(saml2aws --completion-script-bash)"
fi

# Added by Windsurf
export PATH="/Users/dentuzhik/.codeium/windsurf/bin:$PATH"

# Needed for Aider
export PATH="/Users/dentuzhik/.local/bin:$PATH"

# eval "$(direnv hook bash)"
#
# export NODE_EXTRA_CA_CERTS="/Library/Application Support/Cloudflare/certificate.pem"
