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

if [ -z $PMS_SHELL ] || [ -s $PMS_DEBUG ]; then
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
    if [ "$PMS_DEBUG" -eq "1" ]; then
      _pms_message_info "Loading theme '$PMS_THEME' (sh) via local"
    fi
    source $PMS_LOCAL/themes/$PMS_THEME/$PMS_THEME.theme.sh
    theme_loaded=1
  elif [ -f $PMS/themes/$PMS_THEME/$PMS_THEME.theme.sh ]; then
    if [ "$PMS_DEBUG" -eq "1" ]; then
      _pms_message_info "Loading theme '$PMS_THEME' (sh)"
    fi
    source $PMS/themes/$PMS_THEME/$PMS_THEME.theme.sh
    theme_loaded=1
  fi

  # Shell specific theme file
  if [ -f $PMS_LOCAL/themes/$PMS_THEME/$PMS_THEME.theme.$PMS_SHELL ]; then
    if [ "$PMS_DEBUG" -eq "1" ]; then
      _pms_message_info "Loading theme '$PMS_THEME' ($PMS_SHELL) via local"
    fi
    source $PMS_LOCAL/themes/$PMS_THEME/$PMS_THEME.theme.$PMS_SHELL
    theme_loaded=1
  elif [ -f $PMS/themes/$PMS_THEME/$PMS_THEME.theme.$PMS_SHELL ]; then
    if [ "$PMS_DEBUG" -eq "1" ]; then
      _pms_message_info "Loading theme '$PMS_THEME' ($PMS_SHELL)"
    fi
    source $PMS/themes/$PMS_THEME/$PMS_THEME.theme.$PMS_SHELL
    theme_loaded=1
  fi

  if [ "$theme_loaded" -eq "0" ]; then
    _pms_message_error "Theme '$PMS_THEME' could not be loaded, loading the 'default' theme"
    #source $PMS/themes/default/default.theme.$PMS_SHELL
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

  plugin_loaded=0
  # sh may or may not be found, we don't need to notify user if this is not
  # found because shell specific files are more important
  if [ -f $PMS_LOCAL/plugins/$1/$1.plugin.sh ]; then
    if [ "$PMS_DEBUG" -eq "1" ]; then
      _pms_message_info "Loading plugin '$1' (sh) via local"
    fi
    source $PMS_LOCAL/plugins/$1/$1.plugin.sh
    plugin_loaded=1
  # check core plugins
  elif [ -f $PMS/plugins/$1/$1.plugin.sh ]; then
    if [ "$PMS_DEBUG" -eq "1" ]; then
      _pms_message_info "Loading plugin '$1' (sh)"
    fi
    source $PMS/plugins/$1/$1.plugin.sh
    plugin_loaded=1
  fi

  # check local directory first
  if [ -f $PMS_LOCAL/plugins/$1/$1.plugin.$PMS_SHELL ]; then
    if [ "$PMS_DEBUG" -eq "1" ]; then
      _pms_message_info "Loading plugin '$1' ($PMS_SHELL) via local"
    fi
    source $PMS_LOCAL/plugins/$1/$1.plugin.$PMS_SHELL
    plugin_loaded=1
  # check core plugins
  elif [ -f $PMS/plugins/$1/$1.plugin.$PMS_SHELL ]; then
    if [ "$PMS_DEBUG" -eq "1" ]; then
      _pms_message_info "Loading plugin '$1' ($PMS_SHELL)"
    fi
    source $PMS/plugins/$1/$1.plugin.$PMS_SHELL
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
# PMS Manager
# Usage: pms
pms() {
  if [ "$PMS_DEBUG" -eq "1" ]; then
      _pms_message_info "PMS:         $PMS"
      _pms_message_info "PMS_LOCAL:   $PMS_LOCAL"
      _pms_message_info "PMS_SHELL:   $PMS_SHELL"
      _pms_message_info "PMS_PLUGINS: ${PMS_PLUGINS[*]}"
      _pms_message_info "#:           $#"
      _pms_message_info "@:           $@"
      _pms_message_info "0:           $0"
      _pms_message_info "1:           $1"
      _pms_message_info "2:           $2"
      _pms_message_info "3:           $3"
  fi

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
  #echo "    switch           Switch to a specific theme"
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
_pms_command_upgrade() {
  local checkpoint=$PWD
  cd "$PMS"
  _pms_message_section_info "Upgrading to latest PMS version"
  git pull origin master
  _pms_message_info "Copying files"
  cp -v $PMS/templates/bashrc ~/.bashrc
  cp -v $PMS/templates/zshrc ~/.zshrc
  _pms_message_info "Running update scripts for enabled plugins"
  for plugin in "${PMS_PLUGINS[@]}"; do
    if [ -f $PMS_LOCAL/plugins/$plugin/update.sh ]; then
        source $PMS_LOCAL/plugins/$plugin/update.sh
    elif [ -f $PMS/plugins/$plugin/update.sh ]; then
        source $PMS/plugins/$plugin/update.sh
    fi
  done
  _pms_message_success "Upgrade complete, you may need to reload your environment"
  cd "$checkpoint"
  # @todo ask if user wants to reload environment
  #pms "reload"
}
_pms_command_reload() {
  echo "Reloading PMS..."
  # @todo which is best?
  #source ~/.${PMS_SHELL}rc
  exec $PMS_SHELL
  #sh $PMS/pms.sh $PMS_SHELL $PMS_DEBUG
  echo "PMS Reloaded"
}
_pms_command_theme_list() {
  echo
  echo "Core Themes:"
  for theme in $PMS/themes/*; do
    theme=${theme%*/}
    echo "  ${theme##*/}"
  done
  echo
  echo "Local Themes:"
  for theme in $PMS_LOCAL/themes/*; do
    theme=${theme%*/}
    echo "  ${theme##*/}"
  done
  echo
  echo "Current Theme: $PMS_THEME"
  echo
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
  echo "Enabled Plugins:"
  for plugin in "${PMS_PLUGINS[@]}"; do
    plugin=${plugin%*/}
    echo "  ${plugin##*/}"
  done
  echo
}
_pms_command_plugin_enable() {
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
    # is enabled?
    local _is_enabled=0
    for p in "${PMS_PLUGINS[@]}"; do
        if [ "$p" = "$3" ]; then
            _is_enabled=1
            break
        fi
    done
    if [ "$_is_enabled" -eq "0" ]; then
        _pms_message_error "The plugin '$3' is not enabled"
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
    echo "PMS_PLUGINS=(${PMS_PLUGINS[*]})" > ~/.pms.plugins

    # Run uninstall script (if available)
    if [ -f $PMS_LOCAL/plugins/$3/uninstall.sh ]; then
        source $PMS_LOCAL/plugins/$3/uninstall.sh
    elif [ -f $PMS/plugins/$3/uninstall.sh ]; then
        source $PMS/plugins/$3/uninstall.sh
    fi

    _pms_message_success "Plugin has been disabled, you may need to reload environment"
    # @todo Ask user to reload environment
}
### PMS Manager

# 2) environment file loader
# @todo Load plugin environment variable files first so user can override them
# load the plugins and theme second so that they can be modified later
if [ "$PMS_DEBUG" -eq "1" ]; then
  _pms_message_info "PMS Loading Environment Files"
fi
# .pms.plugins
if [ -f ~/.pms.plugins ]; then
  if [ "$PMS_DEBUG" -eq "1" ]; then
    _pms_message_info "loading env file '~/.pms.plugins'"
  fi
  source ~/.pms.plugins
else
  _pms_message_error "~/.pms.plugins could not be found"
fi
# .pms.theme
if [ -f ~/.pms.theme ]; then
  if [ "$PMS_DEBUG" -eq "1" ]; then
    _pms_message_info "loading env file '~/.pms.theme'"
  fi
  source ~/.pms.theme
else
  _pms_message_error "~/.pms.theme could not be found"
fi
# .env
if [ -f ~/.env ]; then
  if [ "$PMS_DEBUG" -eq "1" ]; then
    _pms_message_info "loading env file '~/.env'"
  fi
  source ~/.env
else
  _pms_message_warn "~/.env could not be found"
fi
# .env.$PMS_SHELL
if [ -f ~/.env.$PMS_SHELL ]; then
  if [ "$PMS_DEBUG" -eq "1" ]; then
    _pms_message_info "loading env file '~/.env.$PMS_SHELL'"
  fi
  source ~/.env.$PMS_SHELL
else
  _pms_message_warn "~/.env.$PMS_SHELL could not be found"
fi
# .env.local
if [ -f ~/.env.local ]; then
  if [ "$PMS_DEBUG" -eq "1" ]; then
    _pms_message_info "loading env file '~/.env.local'"
  fi
  source ~/.env.local
else
  _pms_message_warn "~/.env.local could not be found"
fi
# .env.$PMS_SHELL.local
if [ -f ~/.env.$PMS_SHELL.local ]; then
  if [ "$PMS_DEBUG" -eq "1" ]; then
    _pms_message_info "loading env file '~/.env.$PMS_SHELL.local'"
  fi
  source ~/.env.$PMS_SHELL.local
else
  _pms_message_warn "~/.env.$PMS_SHELL.local could not be found"
fi

# Dump some environment variables not that settings are loaded
if [ "$PMS_DEBUG" -eq "1" ]; then
  echo
  _pms_message_info "-=[ PMS ]=-"
  _pms_message_info "PMS:         $PMS"
  _pms_message_info "PMS_LOCAL:   $PMS_LOCAL"
  _pms_message_info "PMS_DEBUG:   $PMS_DEBUG"
  _pms_message_info "PMS_REPO:    $PMS_REPO"
  _pms_message_info "PMS_REMOTE:  $PMS_REMOTE"
  _pms_message_info "PMS_BRANCH:  $PMS_BRANCH"
  _pms_message_info "PMS_THEME:   $PMS_THEME"
  _pms_message_info "PMS_PLUGINS: ${PMS_PLUGINS[*]}"
  _pms_message_info "PMS_SHELL:   $PMS_SHELL"
  echo
  _pms_message_info "-=[ Args ]=-"
  _pms_message_info "1: $1" # PMS_SHELL
  _pms_message_info "2: $2" # PMS_DEBUG
  echo
fi

# 3) Load libraries (sh and PMS_SHELL)
# @todo local overwrites
for lib in $PMS/lib/*.{sh,$PMS_SHELL}; do
  if [ "$PMS_DEBUG" -eq "1" ]; then
    _pms_message_info "Loading Library '$(basename $lib)'"
  fi
  source $lib
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
