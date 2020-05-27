####
# lib/example.bash
####
#
# This file will be loaded if the shell being used is bash
#
if [ "$PMS_DEBUG" -eq "1" ]; then
  echo "[DEBUG] lib/example.bash loaded"
fi
