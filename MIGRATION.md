# Migration

This repo was refactored to be portable (proper Stow packages + XDG paths). If you were previously using `stow .` and/or had `~/.config` symlinked to this repo, follow the steps below.

## 1) Check Your Current State

```sh
ls -la ~/.config
readlink ~/.config || true
```

If `~/.config` is a symlink into `~/.dotfiles`, you need to remove it before stowing the new layout.

## 2) Remove The Old `~/.config` Symlink (If Present)

```sh
if [ -L "$HOME/.config" ]; then
  echo "~/.config is a symlink -> $(readlink "$HOME/.config")"
  mv "$HOME/.config" "$HOME/.config.dotfiles.bak"
  mkdir -p "$HOME/.config"
fi
```

This preserves the old symlink as `~/.config.dotfiles.bak` so you can copy any local files out of it.

## 3) Re-stow Using Explicit Packages

From inside the dotfiles repo:

```sh
cd ~/.dotfiles
stow home config zsh local
```

## 4) Move Local-Only Files (Optional)

### Zsh secrets and machine-specific hooks

If you previously kept secrets under `~/.dotfiles/zsh/secrets.zsh`, the new location is:

```sh
mkdir -p ~/.config/zsh
mv ~/.dotfiles/zsh/secrets.zsh ~/.config/zsh/secrets.zsh 2>/dev/null || true
```

Machine-specific blocks that should not be committed can live in:

- `~/.config/zsh/env.local.zsh` (always, including non-interactive shells)
- `~/.config/zsh/rc.local.zsh` (interactive shells)
- `~/.config/zsh/profile.local.zsh` (login shells)

### GitHub CLI token

If you have a token-containing file in the old config backup, restore it locally (but do not commit it):

```sh
if [ -f "$HOME/.config.dotfiles.bak/gh/hosts.yml" ]; then
  mkdir -p "$HOME/.config/gh"
  cp "$HOME/.config.dotfiles.bak/gh/hosts.yml" "$HOME/.config/gh/hosts.yml"
fi
```

## 5) Sanity Checks

```sh
readlink ~/.zshenv
readlink ~/.tmux.conf
ls -la ~/.config/zsh
```

You should see `.zshenv` and `.tmux.conf` pointing into `~/.dotfiles/home/...`, and `~/.config/zsh` populated from `~/.dotfiles/zsh/.config/zsh`.
