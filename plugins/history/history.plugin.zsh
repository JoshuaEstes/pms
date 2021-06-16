# Records timestamps
setopt extended_history

# deletes dups
setopt hist_expire_dups_first

# Ignores dups
setopt hist_ignore_dups

# ignores commands that start with space
setopt hist_ignore_space

# show command with history expansion to user before it execute
setopt hist_verify

# Share history data
# Fuck this, causes more issues because I have an absurd amount of terms open
#setopt share_history

bindkey '^R' history-incremental-search-backward
