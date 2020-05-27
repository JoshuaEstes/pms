####
# Plugin: pms
####

####
# PMS Manager
#
# Usage: pms [OPTIONS] [COMMAND]
#
# Tool that helps manage PMS, easy to expand and add to
pms() {
  while getopts "dn" o; do
    case ${o} in
      d) PMS_DEBUG=1 ;;
      n) PMS_NO_INTERACTION=1 ;;
    esac
    shift
  done

  # ex: pms plugin list
  if [ ! -z "$1" ] && [ ! -z "$2" ]; then
    if [ -f $PMS_LOCAL/plugins/pms/pms-$1-$2.$PMS_SHELL ]; then
      source $PMS_LOCAL/plugins/pms/pms-$1-$2.$PMS_SHELL
      return
    elif [ -f $PMS_LOCAL/plugins/pms/pms-$1-$2.sh ]; then
      source $PMS_LOCAL/plugins/pms/pms-$1-$2.sh
      return
    elif [ -f $PMS/plugins/pms/pms-$1-$2.$PMS_SHELL ]; then
      source $PMS/plugins/pms/pms-$1-$2.$PMS_SHELL
      return
    elif [ -f $PMS/plugins/pms/pms-$1-$2.sh ]; then
      source $PMS/plugins/pms/pms-$1-$2.sh
      return
    fi
  # ex: pms upgrade
  elif [ ! -z "$1" ]; then
    if [ -f $PMS_LOCAL/plugins/pms/pms-$1.$PMS_SHELL ]; then
      source $PMS_LOCAL/plugins/pms/pms-$1.$PMS_SHELL
      return
    elif [ -f $PMS_LOCAL/plugins/pms/pms-$1.sh ]; then
      source $PMS_LOCAL/plugins/pms/pms-$1.sh
      return
    elif [ -f $PMS/plugins/pms/pms-$1.$PMS_SHELL ]; then
      source $PMS/plugins/pms/pms-$1.$PMS_SHELL
      return
    elif [ -f $PMS/plugins/pms/pms-$1.sh ]; then
      source $PMS/plugins/pms/pms-$1.sh
      return
    fi
  fi

  source $PMS/plugins/pms/pms-help.sh
}
