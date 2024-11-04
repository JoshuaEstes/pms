# vim: set ft=zsh:
# If this is set, zsh sessions will append their history list to the history
# file, rather than replace it. Thus, multiple parallel zsh sessions will all
# have the new entries from their history lists added to the history file, in
# the order that they exit. The file will still be periodically re-written to
# trim it when the number of lines grows 20% beyond the value specified by
# $SAVEHIST (see also the HIST_SAVE_BY_COPY option).
setopt append_history

# Save each command’s beginning timestamp (in seconds since the epoch) and the
# duration (in seconds) to the history file. The format of this prefixed data
# is:
#
# ‘: <beginning time>:<elapsed seconds>;<command>’.
setopt extended_history

# If the internal history needs to be trimmed to add the current command line,
# setting this option will cause the oldest history event that has a duplicate
# to be lost before losing a unique event from the list. You should be sure to
# set the value of HISTSIZE to a larger number than SAVEHIST in order to give
# you some room for the duplicated events, otherwise this option will behave
# just like HIST_IGNORE_ALL_DUPS once the history fills up with unique events.
setopt hist_expire_dups_first

# Do not enter command lines into the history list if they are duplicates of
# the previous event.
setopt hist_ignore_dups

# Remove command lines from the history list when the first character on the
# line is a space, or when one of the expanded aliases contains a leading
# space. Only normal aliases (not global or suffix aliases) have this
# behaviour. Note that the command lingers in the internal history until the
# next command is entered before it vanishes, allowing you to briefly reuse or
# edit the line. If you want to make it vanish right away without entering
# another command, type a space and press return.
setopt hist_ignore_space

# Whenever the user enters a line with history expansion, don’t execute the
# line directly; instead, perform history expansion and reload the line into
# the editing buffer.
setopt hist_verify

# Share history data
# Fuck this, causes more issues because I have an absurd amount of terms open
#setopt share_history

bindkey '^R' history-incremental-search-backward
