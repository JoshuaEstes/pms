####
# Loads one or more .env files, if the file is not found, it will skipp over
# that file.
#
# Usage: _env_load [FILE] [FILE]...
#
# Example: _env_load ~/.env ~/.env.local
#
_env_load() {
  for f in $@; do
    if [ -f $f ]; then
      source $f
    fi
  done
}
