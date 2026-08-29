# dotfiles

Personal macOS configuration for Bash, Git, Neovim, tmux, SSH, and a small set
of desktop applications. Review the files and `Brewfile` before using them on a
different machine.

## Install

Install Homebrew using the current instructions at [brew.sh](https://brew.sh/),
then clone the repository into the expected location:

```sh
git clone https://github.com/dentuzhik/dotfiles.git "$HOME/dotfiles"
cd "$HOME/dotfiles"
brew bundle install
./bootstrap.sh
```

The bootstrap asks before making changes. Existing targets are moved to a
timestamped directory under `~/.dotfiles-backups`, repository submodules are
initialized, and tmux plugin manager is checked out at a pinned revision. It
does not change the login shell.

The Homebrew Bash binary can be selected as the login shell separately after
confirming its path with `brew --prefix bash`. Restart the terminal after
changing shell or dotfile links.

## Runtime tools

Node.js versions are managed by [fnm](https://github.com/Schniz/fnm). The shell
selects the version in `.node-version`; install it after bootstrapping:

```sh
fnm install
```

Install application and language dependencies per project so their versions
remain in project lockfiles. Python command-line applications can be isolated
with `uv tool install`; for example, `uv tool install tmuxp`.

## Neovim

The configuration targets current stable Neovim and uses its built-in
`vim.pack` package manager. The committed `nvim-pack-lock.json` pins plugin
revisions. On first launch, Neovim installs missing plugins.

Run `:checkhealth` to inspect the installation. Use `:packupdate` to review
updates, then write the review buffer to accept them and refresh the lockfile.
Language servers are intentionally installed per language or project rather
than downloaded automatically by the editor.

## tmux

The bootstrap installs the pinned tmux plugin manager checkout. Install the
plugins declared in `.tmux.conf` with prefix + <kbd>I</kbd>, or run:

```sh
"$HOME/.tmux/plugins/tpm/bin/install_plugins"
```

SSH sessions attach to tmux when it is installed. SSH agent, X11, and arbitrary
forwarding are disabled globally in `.ssh/config`.

## iTerm2

To let iTerm2 read the tracked preferences from this repository:

```sh
defaults write com.googlecode.iterm2 PrefsCustomFolder -string "$HOME/dotfiles/iterm2"
defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true
```

Review the preferences file before enabling it on another machine.

## GitHub authentication

SSH authentication uses the 1Password SSH agent configured in `.ssh/config`.
Create or import a GitHub key in 1Password, enable its SSH agent, and add the
public key to GitHub. Then authenticate the GitHub CLI and verify access:

```sh
gh auth login --hostname github.com --git-protocol ssh --web
ssh -T git@github.com
```

Secrets and session credentials do not belong in this repository. Keep them in
1Password, the macOS Keychain, or another dedicated secret store.
