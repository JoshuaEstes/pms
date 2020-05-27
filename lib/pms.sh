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
# Dump various information about the system so we can troubleshoot issues a
# little better
#
# @todo dump to file
_pms_diagnostic_dump() {
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
  echo
  echo "-=[ Shell ]=-"
  echo "SHELL: $SHELL"
  echo
  echo "-=[ Terminal ]=-"
  echo "TERM: $TERM"
  echo
  echo "-=[ OS ]=-"
  echo "OSTYPE: $OSTYPE"
  echo "USER:   $USER"
  echo "umask:  $(umask)"
  case "$OSTYPE" in
    darwin*)
      echo "Product Name:     $(sw_vers -productName)"
      echo "Product Version:  $(sw_vers -productVersion)"
      echo "Build Version:    $(sw_vers -buildVersion)"
      ;;
    linux*)
      echo "Release: $(lsb_release -s -d)"
      ;;
  esac
  echo
  echo "-=[ Programs ]=-"
  echo "git: $(git --version)"
  if [ -x "$(command -v bash)" ]; then
    echo "bash: $(bash --version | grep bash)"
  else
    echo "bash: Not Installed"
  fi
  if [ -x "$(command -v zsh)" ]; then
    echo "zsh: $(zsh --version)"
  else
    echo "zsh: Not Installed"
  fi
  echo
  echo "-=[ Metadata ]=-"
  echo "Created At: $(date)"
  echo
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
