# vim: set ft=zsh:
# Perform implicit tees or cats when multiple redirections are attempted
setopt multios

# If set, parameter expansion, command substitution and arithmetic expansion
# are performed in prompts. Substitutions within prompts do not affect the
# command status.
setopt prompt_subst

# Completions
autoload -U compaudit compinit
