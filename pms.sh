# pms.sh
set -e

echo
echo "0: $0"
echo "1: $1"
echo

if [ "$PMS_DEBUG" -eq "1" ]; then
  echo "[DEBUG] PMS Loading Starting"
fi

# Load general libs
# @todo local overwrites
for lib in $PMS/lib/*.sh; do
  if [ "$PMS_DEBUG" -eq "1" ]; then
    echo "[DEBUG] Library '$lib' Loading..."
  fi
  source $lib
  if [ "$PMS_DEBUG" -eq "1" ]; then
    echo "[DEBUG] Library '$lib' Loaded"
  fi
done

# We need to figure out what shell the user is in and load files based on that
# shell, this should be improved at some point
case "$SHELL" in
  "/bin/bash" | "/usr/bin/bash" )
    SHORT_SHELL=bash ;;
  "/bin/zsh" )
    SHORT_SHELL=zsh ;;
  * )
    SHORT_SHELL=sh ;;
esac

if [ "$PMS_DEBUG" -eq "1" ]; then
  echo "[DEBUG] Shell: '$SHORT_SHELL'"
fi

# Load Environment Variables
# @depends _env_load
# @see lib/env.sh
_env_load ~/.env ~/.env.$SHORT_SHELL ~/.env.local ~/.env.$SHORT_SHELL.local

# theme
# @see lib/pms.sh
_pms_load_theme

# plugins
# @see lib/pms.sh
_pms_load_plugins

# We want to make sure that each shell has it's on "rc" script here
if [ -f $PMS/plugins/pms/pms.plugin.$SHORT_SHELL ]; then
  source $PMS/plugins/pms/pms.plugin.$SHORT_SHELL
else
  echo "[PMS] Could not find: $PMS/plugins/pms/pms.plugin.$SHORT_SHELL"
  exit 1
fi

if [ "$PMS_DEBUG" -eq "1" ]; then
  echo "[DEBUG] PMS Loading Complete"
fi
