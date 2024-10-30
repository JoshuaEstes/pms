# vim: set ft=sh:
####
# Core functions
####

####
# @todo Interactive Helpers
# Allows PMS to ask questions and get confirmations from the user

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
        source $1
        #if [ "$PMS_DEBUG" -eq "1" ]; then
        #    _pms_message_section_info "loaded" "$1"
        #fi
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
  # @todo Check directory exists in either PMS_LOCAL or PMS
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
# Usage: _pms_message "info" "Message"
# Output: Message
####
_pms_message() {
    local type=$1
    local message=$2
    case $type in
        info) printf "\r${color_blue}$message${color_reset}\n" ;;
        success) printf "\r${color_green}$message${color_reset}\n" ;;
        warn) printf "\r${color_yellow}$message${color_reset}\n" ;;
        error) printf "\r${color_red}$message${color_reset}\n" ;;
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
        *) printf "\r\n\t$message\n\n" ;;
    esac
}
