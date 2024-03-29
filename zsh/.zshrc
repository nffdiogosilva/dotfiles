fpath+=($ZDOTDIR/prompt/pure /opt/homebrew/share/zsh/site-functions)

# prompt
RPROMPT='[%D{%H:%M:%S}]'
autoload -U promptinit; promptinit
prompt pure

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
# source $ZDOTDIR/plugins/zsh-vi-mode/zsh-vi-mode.plugin.zsh
# autojump
[ -f /opt/homebrew/etc/profile.d/autojump.sh ] && . /opt/homebrew/etc/profile.d/autojump.sh
# fzf
eval "$(fzf --zsh)"

# aliases
source $ZDOTDIR/aliases

