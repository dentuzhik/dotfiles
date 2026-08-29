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
timestamped directory under `~/.dotfiles-backups` before the requested files
are linked. It does not change the login shell or install desktop applications.

The Homebrew Bash binary can be selected as the login shell separately after
confirming its path with `brew --prefix bash`. Restart the terminal after
changing shell or dotfile links.

## Desktop applications

Homebrew is deliberately limited to command-line tools. Desktop applications
with stable labels are managed separately with a pinned [Installomator
10.9](https://github.com/Installomator/Installomator/releases/tag/v10.9)
package:

```sh
./scripts/install-apps.sh --audit
./scripts/install-apps.sh --install
```

Audit mode downloads the package without installing it. It verifies the
package checksum, Apple notarization and installer identity, extracted script
checksum, label URL resolution, and each application's expected Apple Team ID.
Install mode repeats that audit, requires an interactive terminal and `sudo`,
then installs or updates the applications in
[`apps/installomator-apps.tsv`](apps/installomator-apps.tsv).

Running applications offer **Quit and Update** or **Not Now** and are never
force-killed. Mac App Store copies are left untouched. Docker's label accepts
Docker's license during installation; Docker and Karabiner-Elements can still
require interactive macOS permission approval afterward.

1Password, 1Password CLI, Finicky, and Monaspace remain outside the automated
batch. See the [manual-install list](apps/manual-apps.md) for official sources
and the reason for each exclusion.

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

The tmux configuration uses native features only; it does not download or
execute plugin repositories. SSH sessions attach to tmux when it is installed.
SSH agent, X11, and arbitrary forwarding are disabled globally in
`.ssh/config`.

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
