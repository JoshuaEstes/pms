#!/usr/bin/env bash
set -e
# some defaults
PMS=${PMS:-~/.pms}
PMS_DEBUG=0

main() {
  while getopts "d" o; do
    case ${o} in
      d)
	PMS_DEBUG=1
        ;;
    esac
    shift
  done

  if [ ! -z "$1" ] && [ ! -z "$2" ]; then
    if [ -f $PMS/scripts/pms-$1-$2.sh ]; then
      source $PMS/scripts/pms-$1-$2.sh
    else
      echo "Could not load: $PMS/scripts/pms-$1-$2.sh"
      return
    fi
  elif [ ! -z "$1" ]; then
    if [ -f $PMS/scripts/pms-$1.sh ]; then
      source $PMS/scripts/pms-$1.sh
    else
      echo "Could not load: $PMS/scripts/pms-$1.sh"
      return
    fi
  fi

  source $PMS/scripts/pms-help.sh
}

main "$@"
