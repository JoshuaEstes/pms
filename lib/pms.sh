####
# lib/pms.sh
####

####
# Loads the theme files
#
# Usage: _pms_load_theme default
_pms_load_theme() {
  theme_loaded=0
  # Generic sh theme files
  if [ -f $PMS_LOCAL/themes/$PMS_THEME/$PMS_THEME.theme.sh]; then
    if [ "$PMS_DEBUG" -eq "1" ]; then
      echo "[DEBUG] Loading theme '$PMS_THEME' (sh) via local"
    fi
    source $PMS_LOCAL/themes/$PMS_THEME/$PMS_THEME.theme.sh
    theme_loaded=1
  elif [ -f $PMS/themes/$PMS_THEME/$PMS_THEME.theme.sh ]; then
    if [ "$PMS_DEBUG" -eq "1" ]; then
      echo "[DEBUG] Loading theme '$PMS_THEME' (sh)"
    fi
    source $PMS/themes/$PMS_THEME/$PMS_THEME.theme.sh
    theme_loaded=1
  fi

  # Shell specific theme file
  if [ -f $PMS_LOCAL/themes/$PMS_THEME/$PMS_THEME.theme.$PMS_SHELL ]; then
    if [ "$PMS_DEBUG" -eq "1" ]; then
      echo "[DEBUG] Loading theme '$PMS_THEME' ($PMS_SHELL) via local"
    fi
    source $PMS_LOCAL/themes/$PMS_THEME/$PMS_THEME.theme.$PMS_SHELL
    theme_loaded=1
  elif [ -f $PMS/themes/$PMS_THEME/$PMS_THEME.theme.$PMS_SHELL ]; then
    if [ "$PMS_DEBUG" -eq "1" ]; then
      echo "[DEBUG] Loading theme '$PMS_THEME' ($PMS_SHELL)"
    fi
    source $PMS/themes/$PMS_THEME/$PMS_THEME.theme.$PMS_SHELL
    theme_loaded=1
  fi

  if [ "$theme_loaded" -eq "0" ]; then
    echo "[ERROR] Theme '$PMS_THEME' could not be loaded, loading the 'default' theme"
    #source $PMS/themes/default/default.theme.$PMS_SHELL
    _pms_load_theme default
  fi
}

####
# Loads plugin
#
# Usage: _pms_load_plugin example
#
# loads example.plugin.sh (if available)
# loads example.plugin.$PMS_SHELL (if available)
# loads from $PMS_LOCAL first
# loads from $PMS if not found in $PMS_LOCAL
#
_pms_load_plugin() {
  # sh may or may not be found, we don't need to notify user if this is not
  # found because shell specific files are more important
  if [ -f $PMS_LOCAL/plugins/$1/$1.plugin.sh ]; then
    if [ "$PMS_DEBUG" -eq "1" ]; then
      echo "[DEBUG] Loading plugin '$1' (sh) via local"
    fi
    source $PMS_LOCAL/plugins/$1/$1.plugin.sh
  # check core plugins
  elif [ -f $PMS/plugins/$1/$1.plugin.sh ]; then
    if [ "$PMS_DEBUG" -eq "1" ]; then
      echo "[DEBUG] Loading plugin '$1' (sh)"
    fi
    source $PMS/plugins/$1/$1.plugin.sh
  fi

  # check local directory first
  if [ -f $PMS_LOCAL/plugins/$1/$1.plugin.$PMS_SHELL ]; then
    if [ "$PMS_DEBUG" -eq "1" ]; then
      echo "[DEBUG] Loading plugin '$1' ($PMS_SHELL) via local"
    fi
    source $PMS_LOCAL/plugins/$1/$1.plugin.$PMS_SHELL
  # check core plugins
  elif [ -f $PMS/plugins/$1/$1.plugin.$PMS_SHELL ]; then
    if [ "$PMS_DEBUG" -eq "1" ]; then
      echo "[DEBUG] Loading plugin '$1' ($PMS_SHELL)"
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
