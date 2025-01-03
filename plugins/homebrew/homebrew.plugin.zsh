# vim: set ft=zsh:
####
# Zsh Completions for Homebrew
#
# @see https://docs.brew.sh/Shell-Completion
if type brew &>/dev/null; then
    eval "$(brew shellenv)"
    FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
    autoload -Uz compinit
    compinit
fi
