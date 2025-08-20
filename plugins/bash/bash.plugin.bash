# vim: set ft=sh:
# shellcheck shell=bash
####
# Plugin: bash
####
# Configures history options, common aliases, and completion for Bash.

HISTCONTROL=ignoreboth   # ignore duplicates and commands starting with spaces
HISTSIZE=1000
HISTFILESIZE=2000
shopt -s histappend
shopt -s checkwinsize

# Useful directory listings
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Source personal aliases if present
if [ -f ~/.bash_aliases ]; then
    # shellcheck source=/dev/null
    source ~/.bash_aliases
fi

# Load bash completion if available
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        # shellcheck source=/usr/share/bash-completion/bash_completion disable=SC1091
        source /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        # shellcheck source=/etc/bash_completion disable=SC1091
        source /etc/bash_completion
    fi
fi
