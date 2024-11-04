# If a command is issued that can’t be executed as a normal command, and the
# command is the name of a directory, perform the cd command to that directory.
# This option is only applicable if the option SHIN_STDIN is set, i.e. if
# commands are being read from standard input. The option is designed for
# interactive use; it is recommended that cd be used explicitly in scripts to
# avoid ambiguity.
setopt auto_cd

# Make cd push the old directory onto the directory stack
setopt auto_pushd

# If the argument to a cd command (or an implied cd with the AUTO_CD option
# set) is not a directory, and does not begin with a slash, try to expand the
# expression as if it were preceded by a ‘~’ (see Filename Expansion).
setopt cdable_vars

# Resolve symbolic links to their true values when changing directory. This
# also has the effect of CHASE_DOTS, i.e. a ‘..’ path segment will be treated
# as referring to the physical parent, even if the preceding path segment is a
# symbolic link.
setopt chase_links


# Don’t push multiple copies of the same directory onto the directory stack.
setopt pushd_ignore_dups

setopt pushdminus
