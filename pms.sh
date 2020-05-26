#!/usr/bin/env bash
set -e
####
#
# This is the main entry point, shell rc files should source this script
#

# Default env vars
export PMS=${PMS:-~/.pms}
export PMS_LOCAL=${PMS_LOCAL:-~/.pms/local}
export PMS_THEME=${PMS_THEME:-default}
plugins=(example example2)

# We need to figure out what shell the user is in and load files based on that
# shell, this should be improved at some point
SHORT_SHELL=sh
case "$SHELL" in
  "/bin/bash" | "/usr/bin/bash" )
    SHORT_SHELL=bash ;;
  "/bin/zsh" )
    SHORT_SHELL=zsh ;;
esac

# Make sure we can use some commands
alias pms="$PMS/scripts/pms.sh"

# We want to make sure that each shell has it's on "rc" script here
if [ -f $PMS/plugins/pms/pms.plugin.$SHORT_SHELL ]; then
  source $PMS/plugins/pms/pms.plugin.$SHORT_SHELL
else
  echo "Could not find: $PMS/plugins/pms/pms.plugin.$SHORT_SHELL"
  exit 1
fi
