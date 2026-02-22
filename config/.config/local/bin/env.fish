if not contains "$HOME/.config/local/share/../bin" $PATH
    # Prepending path in case a system-installed binary needs to be overridden
    set -x PATH "$HOME/.config/local/share/../bin" $PATH
end
