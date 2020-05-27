####
# Plugin: pms
# Shell:  bash
####
# @todo move function pms into this plugin
# @todo move other pms files (pms-help), etc to this plugin

####
# PMS Manager
#
# Usage: pms [OPTIONS] [COMMAND]
#
# Tool that helps manage PMS, easy to expand and add to
#
# @todo Move this into the "pms" plugin
pms() {
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
      return
    else
      echo "Could not load: $PMS/scripts/pms-$1-$2.sh"
      return
    fi
  elif [ ! -z "$1" ]; then
    if [ -f $PMS/scripts/pms-$1.sh ]; then
      source $PMS/scripts/pms-$1.sh
      return
    else
      echo "Could not load: $PMS/scripts/pms-$1.sh"
      return
    fi
  fi

  source $PMS/scripts/pms-help.sh
}
