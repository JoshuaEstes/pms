# vim: set ft=sh:
####
# Core functions
#
# Public functions do not start with any underscores. These could be overwritten
# by plugins or be used by plugins. They are considered stable api functions that
# won't change unless a new major version comes out.
# Functions that have one underscore (_) are considered "protected" and can be
# overwritten.
# Function that have two underscores (__) are considered private/internal and
# should never be overwritten.
####

####
# @todo Interactive Helpers
# Allows PMS to ask questions and get confirmations from the user

####
# Used to ask the user a yes/no question
####
_pms_question_yn() {
    local ans
    while true; do
        read -r ans
        case ${ans:0:1} in
            n) return 1;;
            y) return 0;;
            *) echo "ONLY y and n are supported";;
        esac
    done
}
#if _pms_question_yn; then
#    echo "yes"
#fi
#if ! _pms_question_yn; then
#    echo "no"
#fi

####
# Source a given file and provide feedback based on configuration
#
# @todo add options to allow notifying user if file not found
#
# Usage: _pms_source_file [FILE]
#
# Examples:
#   _pms_source_file $PMS/plugins/pms/env
####
_pms_source_file() {
    if [ -f $1 ]; then
        if [ "$PMS_DEBUG" -eq "1" ]; then
            _pms_message "" "source $1"
        fi
        source $1
    #else
    #    _pms_message_error "File '$1' could not be found"
    fi
}

####
# Loads the theme files
#
# Usage: _pms_theme_load [THEME]
#
# Example: _pms_theme_load default
#
# @internal
####
_pms_theme_load() {
  _pms_message_section "info" "theme" "Loading '$PMS_THEME' theme"
  local theme_loaded=0
  # Generic sh theme files
  if [ -f $PMS_LOCAL/themes/$PMS_THEME/$PMS_THEME.theme.sh ]; then
    _pms_source_file $PMS_LOCAL/themes/$PMS_THEME/$PMS_THEME.theme.sh
    theme_loaded=1
  elif [ -f $PMS/themes/$PMS_THEME/$PMS_THEME.theme.sh ]; then
    _pms_source_file $PMS/themes/$PMS_THEME/$PMS_THEME.theme.sh
    theme_loaded=1
  fi

  # Shell specific theme file
  if [ -f $PMS_LOCAL/themes/$PMS_THEME/$PMS_THEME.theme.$PMS_SHELL ]; then
    _pms_source_file $PMS_LOCAL/themes/$PMS_THEME/$PMS_THEME.theme.$PMS_SHELL
    theme_loaded=1
  elif [ -f $PMS/themes/$PMS_THEME/$PMS_THEME.theme.$PMS_SHELL ]; then
    _pms_source_file $PMS/themes/$PMS_THEME/$PMS_THEME.theme.$PMS_SHELL
    theme_loaded=1
  fi

  if [ "$theme_loaded" -eq "0" ]; then
    _pms_message "error" "Theme '$PMS_THEME' could not be loaded, loading the 'default' theme"
    _pms_theme_load default
  fi
}

####
# Loads Plugin
#
# Usage: _pms_load_plugin [PLUGIN] [PLUGIN]...
#
# Example: _pms_load_plugin git git-prompt
#
# @internal
####
_pms_plugin_load() {
  local plugin
  for plugin in "$@"; do
      _pms_message_section "info" "plugin" "Loading '$plugin'"
      local plugin_loaded=0

      # The env file is loaded first as there are options that it may use
      if [[ -f $PMS_LOCAL/plugins/$plugin/env && "$plugin" != "$PMS_SHELL" && "$plugin" != "pms" ]]; then
        _pms_source_file $PMS_LOCAL/plugins/$plugin/env
      fi

      # sh may or may not be found, we don't need to notify user if this is not
      # found because shell specific files are more important
      if [ -f $PMS_LOCAL/plugins/$plugin/$plugin.plugin.sh ]; then
        _pms_source_file $PMS_LOCAL/plugins/$plugin/$plugin.plugin.sh
        plugin_loaded=1
      # check core plugins
      elif [ -f $PMS/plugins/$plugin/$plugin.plugin.sh ]; then
        _pms_source_file $PMS/plugins/$plugin/$plugin.plugin.sh
        plugin_loaded=1
      fi

      # check local directory first
      if [ -f $PMS_LOCAL/plugins/$plugin/$plugin.plugin.$PMS_SHELL ]; then
        _pms_source_file $PMS_LOCAL/plugins/$plugin/$plugin.plugin.$PMS_SHELL
        plugin_loaded=1
      # check core plugins
      elif [ -f $PMS/plugins/$plugin/$plugin.plugin.$PMS_SHELL ]; then
        _pms_source_file $PMS/plugins/$plugin/$plugin.plugin.$PMS_SHELL
        plugin_loaded=1
      fi

      # Let user know plugin could not be found
      if [ "$plugin_loaded" -eq "0" ]; then
          _pms_message_section "error" "plugin" "Plugin '$plugin' could not be loaded"
      fi
  done
}

####
# Checks if a plugin is loaded or not
#
# Usage: _pms_is_plugin_enabled "docker"
_pms_is_plugin_enabled() {
    local plugin=$1

    for p in "${PMS_PLUGINS[@]}"; do
        if [ "$p" = "$plugin" ]; then
            return 0
        fi
    done
    unset p

    return 1
}

####
# Usage: _pms_message "info" "Message"
# Usage: _pms_message "Message"
# Output: Message
####
_pms_message() {
    local type=$1
    local message=$2
    if [ -z $2 ]; then
        message=$1
    fi

    case $type in
        info) printf "\r${color_blue}$message${color_reset}\n" ;;
        success) printf "\r${color_green}$message${color_reset}\n" ;;
        warn) printf "\r${color_yellow}$message${color_reset}\n" ;;
        error) printf "\r${color_red}$message${color_reset}\n" ;;
        debug) printf "\r$message\n" ;;
        *) printf "\r$message\n" ;;
    esac
}

####
# Usage: _pms_message_section "info" "section" "Message"
# Output: [section] Message
####
_pms_message_section() {
    local type=$1
    local section=$2
    local message=$3
    case $type in
        info) printf "\r[${color_blue}$section${color_reset}] $message${color_reset}\n" ;;
        success) printf "\r[${color_green}$section${color_reset}] $message${color_reset}\n" ;;
        warn) printf "\r[${color_yellow}$section${color_reset}] $message${color_reset}\n" ;;
        error) printf "\r[${color_red}$section${color_reset}] $message${color_reset}\n" ;;
        debug) printf "\r[$section] $message\n" ;;
        *) printf "\r[$section] $message\n" ;;
    esac
}

####
# Usage: _pms_message_block "info" "Message"
# Output: Message
####
_pms_message_block() {
    local type=$1
    local message=$2
    case $type in
        info) printf "\r\n\t${color_blue}$message${color_reset}\n\n" ;;
        success) printf "\r\n\t${color_green}$message${color_reset}\n\n" ;;
        warn) printf "\r\n\t${color_yellow}$message${color_reset}\n\n" ;;
        error) printf "\r\n\t${color_red}$message${color_reset}\n\n" ;;
        debug) printf "\r\n\t$message\n\n" ;;
        *) printf "\r\n\t$message\n\n" ;;
    esac
}
