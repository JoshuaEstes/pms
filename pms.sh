# pms.sh
#set -xe

if [ "$PMS_DEBUG" -eq "1" ]; then
  echo "-=[ PMS ]=-"
  echo "PMS:         $PMS"
  echo "PMS_DEBUG:   $PMS_DEBUG"
  echo "PMS_REPO:    $PMS_REPO"
  echo "PMS_REMOTE:  $PMS_REMOTE"
  echo "PMS_BRANCH:  $PMS_BRANCH"
  echo "PMS_THEME:   $PMS_THEME"
  echo "PMS_PLUGINS: $PMS_PLUGINS"
  echo "PMS_SHELL:   $PMS_SHELL"
  if [ -d $PMS ]; then
    echo "Hash:        $(cd $PMS; git rev-parse --short HEAD)"
  else
    echo "Hash:        PMS not installed"
  fi
fi


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

# Load Environment Variables
# @depends _env_load
# @see lib/env.sh
_env_load ~/.env ~/.env.$PMS_SHELL ~/.env.local ~/.env.$PMS_SHELL.local

# We need to figure out what shell the user is in and load files based on that
# shell, this should be improved at some point
case "$SHELL" in
  "/bin/bash" | "/usr/bin/bash" )
    PMS_SHELL=bash ;;
  "/bin/zsh" )
    PMS_SHELL=zsh ;;
  * )
    PMS_SHELL=sh ;;
esac
if [ "$PMS_DEBUG" -eq "1" ]; then
  echo "[DEBUG] PMS_SHELL set to '$PMS_SHELL'"
fi

# theme
# @see lib/pms.sh
_pms_load_theme

# plugins
# @see lib/pms.sh
_pms_load_plugins

# We want to make sure that each shell has it's on "rc" script here
if [ -f $PMS/plugins/pms/pms.plugin.$PMS_SHELL ]; then
  source $PMS/plugins/pms/pms.plugin.$PMS_SHELL
else
  echo "[PMS] Could not find: $PMS/plugins/pms/pms.plugin.$PMS_SHELL"
fi

if [ "$PMS_DEBUG" -eq "1" ]; then
  echo "[DEBUG] PMS Loading Complete"
fi
