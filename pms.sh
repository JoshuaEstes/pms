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
  if [ -f $PMS_LOCAL/themes/$PMS_THEME/$PMS_THEME.theme.sh]; then
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
  # sh may or may not be found, we don't need to notify user if this is not
  # found because shell specific files are more important
  if [ -f $PMS_LOCAL/plugins/$1/$1.plugin.sh ]; then
    if [ "$PMS_DEBUG" -eq "1" ]; then
      _pms_message_info "Loading plugin '$1' (sh) via local"
    fi
    source $PMS_LOCAL/plugins/$1/$1.plugin.sh
  # check core plugins
  elif [ -f $PMS/plugins/$1/$1.plugin.sh ]; then
    if [ "$PMS_DEBUG" -eq "1" ]; then
      _pms_message_info "Loading plugin '$1' (sh)"
    fi
    source $PMS/plugins/$1/$1.plugin.sh
  fi

  # check local directory first
  if [ -f $PMS_LOCAL/plugins/$1/$1.plugin.$PMS_SHELL ]; then
    if [ "$PMS_DEBUG" -eq "1" ]; then
      _pms_message_info "Loading plugin '$1' ($PMS_SHELL) via local"
    fi
    source $PMS_LOCAL/plugins/$1/$1.plugin.$PMS_SHELL
  # check core plugins
  elif [ -f $PMS/plugins/$1/$1.plugin.$PMS_SHELL ]; then
    if [ "$PMS_DEBUG" -eq "1" ]; then
      _pms_message_info "Loading plugin '$1' ($PMS_SHELL)"
    fi
    source $PMS/plugins/$1/$1.plugin.$PMS_SHELL
  # Let user know plugin could not be found
  else
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

if [ "$PMS_DEBUG" -eq "1" ]; then
  _pms_message_info "Initializing PMS"
fi

# 2) environment file loader
# load the plugins and theme first so that they can be modified later
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

if [ "$PMS_DEBUG" -eq "1" ]; then
  _pms_message_info "PMS Load Completed"
fi
