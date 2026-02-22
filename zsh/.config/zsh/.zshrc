# zsh options
setopt AUTO_CD
setopt HIST_SAVE_NO_DUPS
setopt EXTENDED_HISTORY          # Write the history file in the ':start:elapsed;command' format.
setopt SHARE_HISTORY

# navigation
bindkey '\e[A' history-search-backward
bindkey '\e[B' history-search-forward

# Docker CLI completions (fpath must be set before compinit)
fpath=($HOME/.docker/completions $fpath)

# zsh autocomplete
source $ZDOTDIR/completion.zsh

# zsh plugins
source $ZDOTDIR/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source $ZDOTDIR/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Prompt and shell UX tools.
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
eval "$(fzf --zsh)"

# aliases
source $ZDOTDIR/aliases

# Launch yazi and cd into the last selected directory.
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}
zle -N y
bindkey "^Y" y

# Resume foreground job and redraw a clean prompt line.
function Resume {
  fg
  zle push-input
  BUFFER=""
  zle accept-line
}
zle -N Resume
bindkey "^Z" Resume

# bun completions and executable path.
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
