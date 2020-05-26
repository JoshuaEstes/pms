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
  elif [ ! -z "$1" ]; then
    source $PMS/scripts/pms-$1.sh
  fi

  source $PMS/scripts/pms-help.sh
}

main "$@"
