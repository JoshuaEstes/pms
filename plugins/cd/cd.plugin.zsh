# If a command is issued that can’t be executed as a normal command, and the
# command is the name of a directory, perform the cd command to that directory.
# This option is only applicable if the option SHIN_STDIN is set, i.e. if
# commands are being read from standard input. The option is designed for
# interactive use; it is recommended that cd be used explicitly in scripts to
# avoid ambiguity.
setopt auto_cd

# Make cd push the old directory onto the directory stack
setopt auto_pushd

setopt pushd_ignore_dups
setopt pushdminus
