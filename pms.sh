####
# PMS
#
# One framework to manage your Themes, Plugins, and dotfiles
#
####

# Validate we can properly configure the shell
if [ -z $1 ] || [ -z $2 ]; then
    echo
    echo "Usage: pms.sh PMS_SHELL PMS_DEBUG"
    echo
    exit 1
fi

# 1) Set Environment Variable Defaults
PMS_SHELL=$1
PMS_DEBUG=$2
PMS_THEME=default

####
# Initialize colors so we can use these late
#
# @todo add more colors and ability for fg and bg
#
# @internal
####
_pms_initialize_colors() {
  RED=$(printf '\033[31m')
  GREEN=$(printf '\033[32m')
  YELLOW=$(printf '\033[33m')
  BLUE=$(printf '\033[34m')
  BOLD=$(printf '\033[1m')
  RESET=$(printf '\033[m')
}
_pms_initialize_colors

####
# Various Messages and Text Helpers
#
# Example: _pms_message_* "This will be the message"
# Example: _pms_message_section_* "DEBUG" "This will be the message"
# Example: _pms_message_block_* "DEBUG" "This will be the message"
#
# @todo Make better and include documentation
#
_pms_message_info() {
    printf "\r${BLUE}$1${RESET}\n"
}
_pms_message_success() {
    printf "\r${GREEN}$1${RESET}\n"
}
_pms_message_warn() {
    printf "\r${YELLOW}$1${RESET}\n"
}
_pms_message_error() {
    printf "\r${RED}$1${RESET}\n"
}
_pms_message_section_info() {
    printf "\r[${BLUE}$1${RESET}] $2${RESET}\n"
}
_pms_message_section_success() {
    printf "\r[${GREEN}$1${RESET}] $2${RESET}\n"
}
_pms_message_section_warn() {
    printf "\r[${YELLOW}$1${RESET}] $2${RESET}\n"
}
_pms_message_section_error() {
    printf "\r[${RED}$1${RESET}] $2${RESET}\n"
}
_pms_message_block_info() {
    printf "\r\n\t${BLUE}$1${RESET}\n\n"
}
_pms_message_block_success() {
    printf "\r\n\t${GREEN}$1${RESET}\n\n"
}
_pms_message_block_warn() {
    printf "\r\n\t${YELLOW}$1${RESET}\n\n"
}
_pms_message_block_error() {
    printf "\r\n\t${RED}$1${RESET}\n\n"
}

####
# @todo Interactive Helpers
# Allows PMS to ask questions and get confirmations from the user
# @todo Supports Colors

####
# Loads the theme files
#
# Usage: _pms_load_theme [THEME]
#
# Example: _pms_load_theme default
#
# @internal
####
_pms_load_theme() {
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
    _pms_message_error "Theme '$PMS_THEME' could not be loaded, loading the 'default' theme"
    _pms_load_theme default
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
_pms_load_plugin() {
  # @todo Check directory exists in either PMS_LOCAL or PMS
  for plugin in "$@"; do
      local plugin_loaded=0
      # sh may or may not be found, we don't need to notify user if this is not
      # found because shell specific files are more important
      if [ -f $PMS_LOCAL/plugins/$1/$1.plugin.sh ]; then
        _pms_source_file $PMS_LOCAL/plugins/$1/$1.plugin.sh
        plugin_loaded=1
      # check core plugins
      elif [ -f $PMS/plugins/$1/$1.plugin.sh ]; then
        _pms_source_file $PMS/plugins/$1/$1.plugin.sh
        plugin_loaded=1
      fi

      # check local directory first
      if [ -f $PMS_LOCAL/plugins/$1/$1.plugin.$PMS_SHELL ]; then
        _pms_source_file $PMS_LOCAL/plugins/$1/$1.plugin.$PMS_SHELL
        plugin_loaded=1
      # check core plugins
      elif [ -f $PMS/plugins/$1/$1.plugin.$PMS_SHELL ]; then
        _pms_source_file $PMS/plugins/$1/$1.plugin.$PMS_SHELL
        plugin_loaded=1
      fi

      # Let user know plugin could not be found
      if [ "$plugin_loaded" -eq "0" ]; then
        _pms_message_error "Plugin '$1' could not be loaded"
      fi
  done
}

####
# Source a given file and provide feedback based on configuration
#
# @todo add options to allow notifying user if file not found
#
# Usage: _pms_load_file [FILE]
#
# Examples:
#   _pms_load_file $PMS/plugins/pms/env
####
_pms_source_file() {
    if [ -f $1 ]; then
        if [ "$PMS_DEBUG" -eq "1" ]; then
            _pms_message_section_info "loading" "$1"
        fi
        source $1
    #else
    #    _pms_message_error "File '$1' could not be found"
    fi
}

####
# Loads env files. This orders the ENV files in based on priority
#
# @internal
####
_pms_load_env_files() {
    # Load pms first so everything can overwrite them if need be
    _pms_source_file $PMS/plugins/pms/env

    # Load some default shell variables
    _pms_source_file $PMS/plugins/$PMS_SHELL/env

    # load the plugins and theme next so that they can be modified later. They should never be modified
    # by hand and should never really be overwritten.
    _pms_source_file ~/.pms.plugins
    _pms_source_file ~/.pms.theme

    # Load the plugin variables
    for plugin in "${PMS_PLUGINS[@]}"; do
        _pms_source_file $PMS/plugins/$plugin/env
    done

    # These files should have already been sourced from the rc files, this
    # reload them to make sure that settings the users want are overwritten
    # when we load the about env files
    _pms_source_file ~/.env
    _pms_source_file ~/.env.$PMS_SHELL
    _pms_source_file ~/.env.local
    _pms_source_file ~/.env.$PMS_SHELL.local
}

####
# This will load up libraries from the code base. It will load sh and then load
# specific shell libraries
#
# @todo local overwrites
# @internal
####
_pms_load_libraries() {
  for lib in $PMS/lib/*.{sh,$PMS_SHELL}; do
    _pms_source_file $lib
  done
}

####
# Load all enabled plugins
#
# NOTE: Make sure pms is first followed by the $PMS_SHELL
#
# @internal
####
_pms_load_plugins() {
    # make sure the pms and "PMS_SHELL" plugins are loaded up first
    _pms_load_plugin pms $PMS_SHELL
    for plugin in "${PMS_PLUGINS[@]}"; do
      _pms_load_plugin $plugin
    done
}

# 2) environment file loader
_pms_load_env_files
if [ "$PMS_DEBUG" -eq "1" ]; then
    _pms_message_block_info "Current PMS Settings"
    _pms_message_info "PMS:         $PMS"
    _pms_message_info "PMS_LOCAL:   $PMS_LOCAL"
    _pms_message_info "PMS_DEBUG:   $PMS_DEBUG"
    _pms_message_info "PMS_REPO:    $PMS_REPO"
    _pms_message_info "PMS_REMOTE:  $PMS_REMOTE"
    _pms_message_info "PMS_BRANCH:  $PMS_BRANCH"
    _pms_message_info "PMS_THEME:   $PMS_THEME"
    _pms_message_info "PMS_PLUGINS: ${PMS_PLUGINS[*]}"
    _pms_message_info "PMS_SHELL:   $PMS_SHELL\n"
fi

# 3) Load libraries (sh and PMS_SHELL)
_pms_load_libraries

# 4) Load plugins
_pms_load_plugins

# 5) load theme
_pms_load_theme $PMS_THEME
