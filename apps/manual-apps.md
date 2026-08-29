# Applications installed manually

These applications are deliberately excluded from both Homebrew and the
Installomator batch. Install them only from the linked official source and use
their built-in updater where available.

## 1Password

Install [1Password for Mac](https://1password.com/downloads/mac/) directly or
from the Mac App Store. It stores credentials and supplies the SSH agent used
by this repository, so the general-purpose bootstrap must not replace or
upgrade it as root.

## 1Password CLI

Follow the official [1Password CLI installation
guide](https://developer.1password.com/docs/cli/get-started/). This is a
security-sensitive command-line tool rather than a desktop application. The
Installomator 10.9 label also assumes `/usr/local/bin/op` when checking its
version, which is not reliable on Apple Silicon Homebrew systems where the
binary may be under `/opt/homebrew/bin`.

## Finicky

Install a signed release from the official [Finicky
releases](https://github.com/johnste/finicky/releases). Installomator 10.9 has
no stable Finicky label, and major-version upgrades can require an interactive
administrator-authorized migration.

## Monaspace

Download the fonts from the official [Monaspace
releases](https://github.com/githubnext/monaspace/releases) and install the
chosen variants with Font Book. Monaspace is a font family, not an application,
and Installomator 10.9 has no stable label for it.
