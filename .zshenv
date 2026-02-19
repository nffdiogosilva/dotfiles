#!/usr/bin/env zsh

# =============================================================================
# Core PATH — available to all shells (login + non-login)
# =============================================================================
export PATH="$HOME/.cargo/bin:$HOME/.local/bin:/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin"

# =============================================================================
# Dotfiles & XDG base directories
# =============================================================================
export DOTFILES="$HOME/.dotfiles"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$XDG_CONFIG_HOME/local/share"
export XDG_CACHE_HOME="$XDG_CONFIG_HOME/cache"

# =============================================================================
# Editor
# =============================================================================
export EDITOR=hx
export VISUAL=$EDITOR

# =============================================================================
# Zsh directories & history
# =============================================================================
export SHELL=$(brew --prefix)/bin/zsh
export ZDOTDIR="$DOTFILES/zsh"
export HISTFILE="$ZDOTDIR/.zhistory"
export SAVEHIST=10000
export HISTSIZE=12000

# =============================================================================
# Misc
# =============================================================================
export WORDCHARS='*?.[]~=&;!#$%^(){}<>'

# Machine-local secrets (API keys, tokens — never committed)
[[ -f "$ZDOTDIR/secrets.zsh" ]] && source "$ZDOTDIR/secrets.zsh"
