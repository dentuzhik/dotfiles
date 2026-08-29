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

## Bash and Zsh

The shared environment and aliases live under `.config/shell`. Bash and Zsh
keep separate completion, history, prompt, and tool-integration code in their
own startup files. Installing these dotfiles does not change the account's
default login shell.

Run either shell temporarily from an existing terminal:

```sh
zsh -l
bash -l
```

This starts a nested login shell; run `exit` to return to the previous one. To
replace the current shell process instead, use `exec zsh -l` or `exec bash -l`.
Check the shell that is actually running with `ps -p $$ -o command=`. The
`$SHELL` variable identifies the account's default login shell and does not
necessarily identify the current process.

For permanent side-by-side iTerm2 profiles:

1. Open **iTerm2 Settings → Profiles** and duplicate the current profile twice.
2. Name the copies **Zsh** and **Bash**.
3. Under **General → Command**, select **Custom Shell** rather than **Login
   Shell**.
4. Set the Zsh shell path to `/bin/zsh`.
5. Find the Bash path with `command -v bash` and set the Bash shell path to that
   absolute path; on Apple Silicon Homebrew this is normally
   `/opt/homebrew/bin/bash`.
6. Optionally assign each profile a keyboard shortcut under **Keys**.

iTerm2 runs a Custom Shell as a login shell, as described in its [profile
documentation](https://iterm2.com/documentation-preferences-profiles-general.html).
New windows opened with either profile therefore load the corresponding
configuration. Explicit profile shells leave the account login shell unchanged
and make switching reversible. If a single system-wide default is preferred
later, use `chsh -s /bin/zsh` for Zsh; switch Homebrew Bash only after ensuring
its absolute path is present in `/etc/shells`.

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
