# My dotfiles

Managed with [GNU Stow](https://www.gnu.org/software/stow/) — symlinks everything into `$HOME`.

## Quick start (fresh machine)

```sh
bash <(curl -sL https://raw.githubusercontent.com/nffdiogosilva/dotfiles/main/install.sh)
```

This installs Homebrew, all dependencies (including building [Helix](https://github.com/nffdiogosilva/helix) from source), clones the repo, and runs `stow .`.

## Manual installation

Requires macOS (Apple Silicon) and [Homebrew](https://brew.sh).

```sh
brew install stow
git clone git@github.com:nffdiogosilva/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
git submodule update --init --recursive
stow .
```

## What's included

| Tool            | Config path                  |
| --------------- | ---------------------------- |
| Zsh             | `zsh/`, `.zshenv`            |
| Starship prompt | `.config/starship.toml`      |
| Helix editor    | `.config/helix/`             |
| Ghostty         | `.config/ghostty/`           |
| Lazygit         | `.config/lazygit/`           |
| Yazi            | `.config/yazi/`              |
| AeroSpace       | `.config/aerospace/`         |
| GitHub CLI      | `.config/gh/`                |
| GitHub Dash     | `.config/gh-dash/`           |
| pgcli           | `.config/pgcli/`             |
| Amp             | `.config/amp/`               |
| Shell scripts   | `.local/bin/`                |

## Secrets

API keys and tokens should go in `zsh/secrets.zsh` (gitignored).
This file is auto-sourced by `.zshenv` if it exists.
