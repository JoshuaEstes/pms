# vim: set ft=zsh:
# shellcheck shell=sh
# Perform implicit tees or cats when multiple redirections are attempted
setopt multios

# If set, parameter expansion, command substitution and arithmetic expansion
# are performed in prompts. Substitutions within prompts do not affect the
# command status.
setopt prompt_subst

# Completions
autoload -U compaudit compinit

completion_dump="${PMS_CACHE_DIR}/zcompdump"
if compaudit >/dev/null 2>&1; then
    mkdir -p "${PMS_CACHE_DIR}"
    compinit -d "${completion_dump}"
else
    printf 'pms: insecure completion directories detected, skipping compinit\n' >&2
fi
