####
# lib/example.sh
####
#
# This file will be loaded for ANY shell. This means that we could be using
# bash, zsh, or some other shell. These files should have the most generic code
# in them
#
if [ "$PMS_DEBUG" -eq "1" ]; then
  echo "[DEBUG] lib/example.sh loaded"
fi