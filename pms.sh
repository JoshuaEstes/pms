####
# PMS
#
# One framework to manage your Themes, Plugins, and dotfiles
#
####
# 1) Environment Variable Defaults
PMS_SHELL=$1
PMS_DEBUG=$2
PMS_THEME=default

if [ -z $PMS_SHELL ] || [ -z $PMS_DEBUG ]; then
    echo
    echo "Usage: pms.sh PMS_SHELL PMS_DEBUG"
    echo
    exit 1
fi

####
# Initialize colors so we can use these late
# @todo make better
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
_pms_load_theme() {
  theme_loaded=0
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
# Usage: _pms_load_plugin [PLUGIN]
#
# Example: _pms_load_plugin git
#
_pms_load_plugin() {
  # @todo Check directory exists in either PMS_LOCAL or PMS
  # @todo add blacklist for "pms", "bash", "zsh", etc.
  plugin_loaded=0
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
}

####
# This is used to set the $PMS_SHELL environment variable. It will overwrite it
# if it is currently defined as well
#
# Usage: _pms_shell_set
#
# @todo figure out if this is event being used
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
    _pms_message_info "PMS_SHELL set to '$PMS_SHELL'"
  fi
}

####
# Source a given file and provide feedback based on configuration
#
# Usage: _pms_load_file [FILE]
#
# Examples:
#   _pms_load_file $PMS/plugins/pms/env
#
_pms_source_file() {
    if [ -f $1 ]; then
        if [ "$PMS_DEBUG" -eq "1" ]; then
            _pms_message_section_info "loading" "$1"
        fi
        source $1
    fi
}

####
# PMS Manager
# Usage: pms
pms() {
  if [ ! -z "$1" ] && [ ! -z "$2" ]; then
      type _pms_command_${1}_${2} &>/dev/null && {
          _pms_command_${1}_${2} "$@"
          return $?
      }
  fi

  if [ ! -z "$1" ]; then
      type _pms_command_${1} &>/dev/null && {
          _pms_command_${1} "$@"
          return $?
      }
  fi

  _pms_command_help
  return 1
}
_pms_command_about() {
  echo
  echo "PMS Manager"
  echo "Making you more productive in your shell than a turtle"
  echo
  echo "Source:         https://github.com/JoshuaEstes/pms"
  echo "User Docs:      https://joshuaestes.github.io/pms/"
  echo "Developer Docs: https://github.com/JoshuaEstes/pms/wiki"
  echo

  return 0
}
_pms_command_help() {
  echo
  echo "Usage: pms [OPTIONS] COMMAND"
  echo
  echo "Commands:"
  echo "  about              Show PMS information"
  echo "  help               Show help messages"
  echo "  upgrade            Upgrade PMS to latest version"
  echo "  diagnostic         Outputs diagnostic information"
  echo "  reload             Reloads all of PMS"
  echo "  theme              Helps to manage themes"
  echo "    list             Displays available themes"
  echo "    switch           Switch to a specific theme"
  #echo "    preview          Preview theme"
  #echo "    validate         Validate theme"
  #echo "    reload           Reloads theme"
  echo "  plugin             Helps to manage plugins"
  echo "    list             Lists all available plugins"
  echo "    enable           Enables and install plugin"
  echo "    disable          Disables a plugin"
  #echo "    update           Updates a plugin"
  #echo "    validate         Validate plugin"
  #echo "    reload           Reloads enabled plugins"
  echo

  return 0
}
_pms_command_diagnostic() {
    # @todo Alert user to any known issues with configurations
    echo
    echo "-=[ PMS ]=-"
    echo "PMS:         $PMS"
    echo "PMS_LOCAL:   $PMS_LOCAL"
    echo "PMS_DEBUG:   $PMS_DEBUG"
    echo "PMS_REPO:    $PMS_REPO"
    echo "PMS_REMOTE:  $PMS_REMOTE"
    echo "PMS_BRANCH:  $PMS_BRANCH"
    echo "PMS_THEME:   $PMS_THEME"
    echo "PMS_PLUGINS: ${PMS_PLUGINS[*]}"
    echo "PMS_SHELL:   $PMS_SHELL"
    if [ -d $PMS ]; then
      echo "Hash:        $(cd $PMS; git rev-parse --short HEAD)"
    else
      echo "Hash:        PMS not installed"
    fi
    echo "~/.pms.theme"
    cat ~/.pms.theme
    echo
    echo "~/.pms.plugins"
    cat ~/.pms.plugins
    echo
    echo "-=[ Shell ]=-"
    echo "SHELL: $SHELL"
    case "$PMS_SHELL" in
      bash)
        echo "BASHOPTS: $BASHOPTS"
        ;;
      zsh)
        echo "ZSH_PATHCLEVEL: $ZSH_PATCHLEVEL"
        ;;
    esac
    echo
    echo "-=[ Terminal ]=-"
    echo "TERM:                 $TERM"
    echo "TERM_PROGRAM:         $TERM_PROGRAM"
    echo "TERM_PROGRAM_VERSION: $TERM_PROGRAM_VERSION"
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
    if [ -x "$(command -v fish)" ]; then
      echo "fish: $(fish --version)"
    else
      echo "fish: Not Installed"
    fi
    echo
    echo "-=[ Metadata ]=-"
    echo "Created At: $(date)"
    echo
}
_pms_command_upgrade() {
  local checkpoint=$PWD
  cd "$PMS"
  _pms_message_block_info "Upgrading to latest PMS version"
  git pull origin master || {
      _pms_message_error "Error pulling down updates..."
      return 1
  }
  _pms_message_block_info "Copying files"
  cp -v $PMS/templates/bashrc ~/.bashrc
  cp -v $PMS/templates/zshrc ~/.zshrc
  _pms_message_block_info "Running update scripts for enabled plugins..."
  for plugin in "${PMS_PLUGINS[@]}"; do
    if [ -f $PMS_LOCAL/plugins/$plugin/update.sh ]; then
        _pms_message_section_info "$plugin (local)" "plugin updating..."
        source $PMS_LOCAL/plugins/$plugin/update.sh
    elif [ -f $PMS/plugins/$plugin/update.sh ]; then
        _pms_message_section_info $plugin "plugin updating..."
        source $PMS/plugins/$plugin/update.sh
    fi
  done
  _pms_message_block_info "Completed update scripts"
  _pms_message_block_success "Upgrade complete, you may need to reload your environment"
  cd "$checkpoint"
  # @todo ask if user wants to run pms reload
}
_pms_command_reload() {
  _pms_message_block_info "Reloading PMS..."
  # @todo which is best?
  #source ~/.${PMS_SHELL}rc
  exec $PMS_SHELL --login
  #sh $PMS/pms.sh $PMS_SHELL $PMS_DEBUG
}
_pms_command_theme_list() {
  _pms_message_block_info "Core Themes"
  for theme in $PMS/themes/*; do
    theme=${theme%*/}
    _pms_message_info "${theme##*/}"
  done
  _pms_message_block_info "Local Themes"
  for theme in $PMS_LOCAL/themes/*; do
    theme=${theme%*/}
    _pms_message_info "${theme##*/}"
  done
  _pms_message_block_success "Current Theme: $PMS_THEME"
}
_pms_command_theme_switch() {
    # Does theme exist?
    if [ ! -d $PMS_LOCAL/themes/$3 ] && [ ! -d $PMS/themes/$3 ]; then
        _pms_message_error "The theme '$3' is invalid"
        return 1
    fi
    # @todo make all this better and support PMS_LOCAL
    if [ -f $PMS/themes/$PMS_THEME/uninstall.sh ]; then
        _pms_source_file $PMS/themes/$PMS_THEME/uninstall.sh
    fi
    echo "PMS_THEME=$3" > ~/.pms.theme
    PMS_THEME=$3
    # @todo make all this better and support PMS_LOCAL
    if [ -f $PMS/themes/$3/install.sh ]; then
        _pms_source_file $PMS/themes/$3/install.sh
    fi
    _pms_load_theme $3
}
_pms_command_plugin_list() {
  echo
  echo "Core Plugins:"
  for plugin in $PMS/plugins/*; do
    plugin=${plugin%*/}
    echo "  ${plugin##*/}"
  done
  echo
  echo "Local Plugins:"
  for plugin in $PMS_LOCAL/plugins/*; do
    plugin=${plugin%*/}
    echo "  ${plugin##*/}"
  done
  echo
  echo "Enabled Plugins: ${PMS_PLUGINS[*]}"
  echo
}
_pms_command_plugin_enable() {
    # @todo support for multiple plugins at a time
    # Does directory exist?
    if [ ! -d $PMS_LOCAL/plugins/$3 ] && [ ! -d $PMS/plugins/$3 ]; then
        _pms_message_error "The plugin '$3' is invalid and cannot be enabled"
        return 1
    fi

    # Check plugin is not already enabled
    for p in "${PMS_PLUGINS[@]}"; do
        if [ "$p" = "$3" ]; then
            _pms_message_error "The plugin '$3' is already enabled"
            return 1
        fi
    done

    _pms_message_info "Adding '$3' to ~/.pms.plugins"
    PMS_PLUGINS+=($3)
    echo "PMS_PLUGINS=(${PMS_PLUGINS[*]})" > ~/.pms.plugins

    _pms_message_info "Checking for plugin install script"
    if [ -f $PMS_LOCAL/plugins/$3/install.sh ]; then
        source $PMS_LOCAL/plugins/$3/install.sh
    elif [ -f $PMS/plugins/$3/install.sh ]; then
        source $PMS/plugins/$3/install.sh
    fi

    _pms_message_info "Loading plugin"
    _pms_load_plugin $3
}
_pms_command_plugin_disable() {
    # @todo support for multiple plugins at a time
    local _plugin_enabled=0
    for p in "${PMS_PLUGINS[@]}"; do
        if [ "$PMS_DEBUG" -eq "1" ]; then
            _pms_message_info "'$p' = '$3'"
        fi
        if [ "$p" = "${3}" ]; then
            _plugin_enabled=1
        fi
    done

    if [ "$_plugin_enabled" -eq "0" ]; then
        _pms_message_section_error "$3" "The plugin is not enabled"
        return 1
    fi

    # Remove from plugins
    local _plugins=()
    for i in "${PMS_PLUGINS[@]}"; do
        if [ "$i" != "$3" ]; then
            _plugins+=($i)
        fi
    done
    PMS_PLUGINS=$_plugins
    # save .pms.plugins
    echo "PMS_PLUGINS=(${_plugins[*]})" > ~/.pms.plugins
    _pms_source_file ~/.pms.plugins

    # Run uninstall script (if available)
    if [ -f $PMS_LOCAL/plugins/$3/uninstall.sh ]; then
        source $PMS_LOCAL/plugins/$3/uninstall.sh
    elif [ -f $PMS/plugins/$3/uninstall.sh ]; then
        source $PMS/plugins/$3/uninstall.sh
    fi

    _pms_message_section_success "$3" "Plugin has been disabled, you will need to reload pms"
    # @todo Ask user to reload environment
}
### PMS Manager

# 2) environment file loader
if [ "$PMS_DEBUG" -eq "1" ]; then
  _pms_message_block_info "Loading Environment Files"
fi
# Load pms first so everything can overwrite them if need be
_pms_source_file $PMS/plugins/pms/env
# Load some default shell variables
_pms_source_file $PMS/plugins/$PMS_SHELL/env
# load the plugins and theme next so that they can be modified later. They should never be modified
# by hand and should never really be overwritten.
_pms_source_file ~/.pms.plugins
_pms_source_file ~/.pms.theme
# Load the plugin variables
if [ "$PMS_DEBUG" -eq "1" ]; then
    _pms_message_section_info "Enabled Plugins" "${PMS_PLUGINS[*]}"
fi
for plugin in "${PMS_PLUGINS[@]}"; do
    _pms_source_file $PMS/plugins/$plugin/env
done
_pms_source_file ~/.env
_pms_source_file ~/.env.$PMS_SHELL
_pms_source_file ~/.env.local
_pms_source_file ~/.env.$PMS_SHELL.local

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
# @todo local overwrites
for lib in $PMS/lib/*.{sh,$PMS_SHELL}; do
  _pms_source_file $lib
done

# 4) Load plugins
# make sure the pms and "PMS_SHELL" plugins are loaded up
_pms_load_plugin pms
_pms_load_plugin $PMS_SHELL
for plugin in "${PMS_PLUGINS[@]}"; do
  _pms_load_plugin $plugin
done

# 5) load theme
_pms_load_theme $PMS_THEME
