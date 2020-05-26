#!/usr/bin/env sh
set -e

# Default env vars
PMS=${PMS:-~/.pms}

# We need to figure out what shell the user is in and load files based on that
# shell, this should be improved at some point
SHORT_SHELL=sh
case "$SHELL" in
  "/bin/bash" | "/usr/bin/bash" )
    SHORT_SHELL=bash ;;
  "/bin/zsh" )
    SHORT_SHELL=zsh ;;
esac

# Initialize
echo $SHORT_SHELL
echo $PMS
if [ -f $PMS/plugins/pms/pms.plugin.$SHORT_SHELL ]; then
  source $PMS/plugins/pms/pms.plugin.$SHORT_SHELL
else
  echo "Shit done fucked up 😒"
fi
