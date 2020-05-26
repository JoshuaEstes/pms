####
# lib/pms.sh
####
# Required Environment Variables
PMS=${PMS:-~/.pms}

####
#
# Usage: pms [OPTIONS] [COMMAND]
#
# Tool that helps manage PMS, easy to expand and add to
#
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

####
# "loads" the theme file
#
# Usage: _pms_load_theme
#
# @todo this is more like "config"
_pms_load_theme() {
  if [ -f ~/.pms.theme ]; then
    source ~/.pms.theme
  fi
}

# @todo this is more like "config"
_pms_load_plugins() {
  if [ -f ~/.pms.plugins ]; then
    source ~/.pms.plugins
  fi
}
