#!/usr/bin/env zsh

# dotfiles
export DOTFILES="$HOME/.dotfiles"

# XDG
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$XDG_CONFIG_HOME/local/share"
export XDG_CACHE_HOME="$XDG_CONFIG_HOME/cache"

# editor
export EDITOR=/opt/homebrew/bin/hx
export VISUAL=$EDITOR

# zsh
export ZDOTDIR="$DOTFILES/zsh"
export HISTFILE="$ZDOTDIR/.zhistory"    # History filepath
export SAVEHIST=10000                   # Maximum events in history file
export HISTSIZE=12000                   # Maximum events for internal history

# nodejs
export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
