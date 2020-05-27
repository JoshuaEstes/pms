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
# @todo Move this into the "pms" plugin
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
  echo "PMS_LOCAL:   $PMS_LOCAL"
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
# Loads the theme files
#
# Usage: _pms_load_theme default
_pms_load_theme() {
  if [ -f $PMS_LOCAL/themes/$PMS_THEME/$PMS_THEME.theme.$PMS_SHELL ]; then
    if [ "$PMS_DEBUG" -eq "1" ]; then
      echo "[DEBUG] Loading theme '$PMS_THEME' via local"
    fi
    source $PMS_LOCAL/themes/$PMS_THEME/$PMS_THEME.theme.$PMS_SHELL
  elif [ -f $PMS/themes/$PMS_THEME/$PMS_THEME.theme.$PMS_SHELL ]; then
    if [ "$PMS_DEBUG" -eq "1" ]; then
      echo "[DEBUG] Loading theme '$PMS_THEME'"
    fi
    source $PMS/themes/$PMS_THEME/$PMS_THEME.theme.$PMS_SHELL
  else
    echo "[ERROR] Theme '$PMS_THEME' could not be loaded, loading the 'default' theme"
    source $PMS/themes/default/default.theme.$PMS_SHELL
  fi
}

####
# Loads plugin
#
# Usage: _pms_load_plugin example
#
_pms_load_plugin() {
  # check local directory first
  if [ -f $PMS_LOCAL/plugins/$1/$1.plugin.$PMS_SHELL ]; then
    if [ "$PMS_DEBUG" -eq "1" ]; then
      echo "[DEBUG] Loading plugin '$1' via local"
    fi
    source $PMS_LOCAL/plugins/$1/$1.plugin.$PMS_SHELL
  # check core plugins
  elif [ -f $PMS/plugins/$1/$1.plugin.$PMS_SHELL ]; then
    if [ "$PMS_DEBUG" -eq "1" ]; then
      echo "[DEBUG] Loading plugin '$1'"
    fi
    source $PMS/plugins/$1/$1.plugin.$PMS_SHELL
  # Let user know plugin could not be found
  else
    echo "[ERROR] Plugin '$1' could not be loaded"
  fi
}

####
# This is used to set the $PMS_SHELL environment variable. It will overwrite it
# if it is currently defined as well
#
# Usage: _pms_shell_set
#
_pms_shell_set() {
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
}
