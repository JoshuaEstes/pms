#!/usr/bin/env bash
####
#
# pms script to help manage everything
#
####
set -e
PMS=${PMS:-~/.pms}

main() {
  if [ ! -z "$1" ] && [ ! -z "$2" ]; then
    source $PMS/scripts/pms-$1-$2.sh
    exit $?
  elif [ ! -z "$1" ]; then
    source $PMS/scripts/pms-$1.sh
    exit $?
  fi

  source $PMS/scripts/pms-help.sh
  exit 1
}

main "$@"
