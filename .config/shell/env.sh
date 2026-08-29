# Shared login environment for Bash and Zsh. Keep this file POSIX-compatible.

if [ "${DOTFILES_SHELL_ENV_LOADED:-0}" = 1 ]; then
    return 0
fi
DOTFILES_SHELL_ENV_LOADED=1

export LANG="en_US.UTF-8"
export LC_CTYPE="$LANG"
export EDITOR="nvim"
export VISUAL="$EDITOR"
export DOTFILES_HOME="${DOTFILES_HOME:-$HOME/dotfiles}"

path_prepend() {
    [ -d "$1" ] || return 0
    case ":$PATH:" in
        *":$1:"*) ;;
        *) PATH="$1:$PATH" ;;
    esac
}

path_append() {
    [ -d "$1" ] || return 0
    case ":$PATH:" in
        *":$1:"*) ;;
        *) PATH="$PATH:$1" ;;
    esac
}

# Resolve Homebrew from trusted installation paths, not a project-controlled PATH.
BREW_BIN=""
for candidate in /opt/homebrew/bin/brew /usr/local/bin/brew /home/linuxbrew/.linuxbrew/bin/brew; do
    if [ -x "$candidate" ]; then
        BREW_BIN="$candidate"
        break
    fi
done

if [ -n "$BREW_BIN" ]; then
    eval "$("$BREW_BIN" shellenv)"
    GIT_PREFIX="$("$BREW_BIN" --prefix git 2>/dev/null || true)"
    if [ -n "$GIT_PREFIX" ]; then
        path_append "$GIT_PREFIX/share/git-core/contrib/diff-highlight"
    fi
fi

path_prepend "$HOME/.fastlane/bin"
path_prepend "$HOME/.rbenv/shims"
path_prepend "$HOME/.codeium/windsurf/bin"
path_prepend "$HOME/.rover/bin"
path_prepend "$HOME/Library/pnpm"
path_prepend "$HOME/.bun/bin"
path_prepend "$HOME/.local/bin"
path_prepend /usr/local/sbin
export PATH

unset -f path_prepend path_append 2>/dev/null || true
unset candidate BREW_BIN GIT_PREFIX
