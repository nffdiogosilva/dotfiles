#!/usr/bin/env zsh

export PATH=/opt/homebrew/bin:/usr/local/bin:$PATH

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
export ZDOTDIR="$DOTFILES/zsh"
export HISTFILE="$ZDOTDIR/.zhistory"    # History filepath
export SAVEHIST=10000                   # Maximum events in history file
export HISTSIZE=12000                   # Maximum events for internal history

# export ZELLIJ_CONFIG_DIR="$XDG_CONFIG_HOME/zellij"

# nodejs
export NVM_DIR="$HOME/.nvm"
  [ -s "/usr/local/bin/opt/nvm/nvm.sh" ] && \. "/usr/local/bin/opt/nvm/nvm.sh"  # This loads nvm
