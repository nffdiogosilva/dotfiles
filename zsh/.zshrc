export PATH=/opt/homebrew/bin:$HOME/.local/bin:$PATH

# prompt
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
# zsh options
setopt AUTO_CD
setopt HIST_SAVE_NO_DUPS
setopt EXTENDED_HISTORY          # Write the history file in the ':start:elapsed;command' format.
setopt SHARE_HISTORY             # Share history between all sessions.

# navigation
bindkey '\e[A' history-search-backward
bindkey '\e[B' history-search-forward

# zsh autocomplete
source $ZDOTDIR/completion.zsh
# zsh plugins
source $ZDOTDIR/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source $ZDOTDIR/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# fzf
eval "$(fzf --zsh)"

# python
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# nodejs
export NVM_DIR="$HOME/.nvm"
[ -s "$(brew --prefix)/opt/nvm/nvm.sh" ] && \. "$(brew --prefix)/opt/nvm/nvm.sh"  # This loads nvm
[ -s "$(brew --prefix)/opt/nvm/etc/bash_completion.d/nvm" ] && \. "$(brew --prefix)/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion


# aliases
source $ZDOTDIR/aliases

