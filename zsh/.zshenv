#!/usr/bin/env zsh

# Compatibility shim.
#
# If an existing shell has exported ZDOTDIR="$HOME/.dotfiles/zsh" (old layout),
# zsh will source $ZDOTDIR/.zshenv and *will not* look at $HOME/.zshenv.
#
# This file forwards to the real entrypoint at $HOME/.zshenv, which sets the
# new XDG-based ZDOTDIR (typically $XDG_CONFIG_HOME/zsh).

[[ -f "$HOME/.zshenv" ]] && source "$HOME/.zshenv"
