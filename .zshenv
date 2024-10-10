#!/usr/bin/env zsh

export PATH=/opt/homebrew/bin:/usr/local/bin

# dotfiles
export DOTFILES="$HOME/.dotfiles"

# XDG
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$XDG_CONFIG_HOME/local/share"
export XDG_CACHE_HOME="$XDG_CONFIG_HOME/cache"

# editor
export EDITOR=$(brew --prefix)/bin/hx
export VISUAL=$EDITOR

# zsh
export SHELL=$(brew --prefix)/bin/zsh
export ZDOTDIR="$DOTFILES/zsh"
export HISTFILE="$ZDOTDIR/.zhistory"    # History filepath
export SAVEHIST=10000                   # Maximum events in history file
export HISTSIZE=12000                   # Maximum events for internal history

# Workaround to make zellij load env vars since it doesn't support "login shell"
source $ZDOTDIR/.zshrc
