####
# PMS
#
# Main entry point for PMS. Loads libraries, plugins, and themes for the
# requested shell.
#
# Usage:
#   PMS=/path/to/pms ./pms.sh bash
#
# Environment Variables:
#   PMS          Path to the PMS installation directory
#   PMS_DEBUG    Set to 1 to enable verbose debug output
#   PMS_SHELL    Target shell to configure (e.g., bash, zsh)
#   PMS_PLUGINS  Space-separated list of plugins to load
#   PMS_THEME    Name of the theme to load
####
# shellcheck shell=bash

# Define shells supported by PMS
PMS_SUPPORTED_SHELLS="bash zsh"

# Validate we can properly configure the shell
if [ -z "$1" ]; then
    echo
    echo "Usage: pms.sh PMS_SHELL"
    echo
    exit 1
fi
PMS_SHELL="$1"

if [ -z "$PMS" ]; then
    echo "The PMS variable is not set. I have no idea what you want me to load."
    exit 1
fi

# We want to make sure that ALL the PMS variables are set if the user does not
# set them in one of the env files
# shellcheck source=plugins/pms/env disable=SC1091
source "$PMS/plugins/pms/env"
if [ 1 -eq "${PMS_DEBUG:-0}" ]; then
    echo "source $PMS/plugins/pms/env"
fi

# Ensure the requested shell is supported and its environment file exists
case " $PMS_SUPPORTED_SHELLS " in
    *" $PMS_SHELL "*) ;;
    *)
        echo "Unsupported shell: $PMS_SHELL"
        exit 1
        ;;
esac

PMS_SHELL_ENV_FILE="$PMS/plugins/$PMS_SHELL/env"
if [ ! -f "$PMS_SHELL_ENV_FILE" ]; then
    echo "Environment file not found: $PMS_SHELL_ENV_FILE"
    exit 1
fi

# If the shell has any variables that need to be set, we need to make sure they get set
# shellcheck disable=SC1090
source "$PMS_SHELL_ENV_FILE"
if [ 1 -eq "${PMS_DEBUG:-0}" ]; then
    echo "source $PMS_SHELL_ENV_FILE"
fi

####
# This will load up libraries from the code base. It will load sh and then load
# specific shell libraries
#
# @internal
####
for lib in "$PMS"/lib/*.{sh,$PMS_SHELL}; do
    # @todo load all local libraries
    # shellcheck disable=SC1090
    source "$lib"
    if [ 1 -eq "${PMS_DEBUG:-0}" ]; then
        echo "source $lib"
    fi
done
unset lib

_pms_source_file "$HOME/.pms.plugins"
_pms_source_file "$HOME/.pms.theme"

# Load project configuration if present
_pms_project_file_load

# Load the PMS and SHELL plugins
_pms_time "pms" _pms_plugin_load pms
_pms_time "$PMS_SHELL" _pms_plugin_load "$PMS_SHELL"

if [ "${PMS_DEBUG:-0}" -eq 1 ]; then
    # If debug is enabled, we want to see the current settings at this point
    _pms_message_block "info" "-=[ PMS Settings ]=-"
    _pms_message "info"  "PMS                  : $PMS"
    _pms_message "info"  "PMS_CACHE_DIR        : $PMS_CACHE_DIR"
    _pms_message "info"  "PMS_LOG_DIR          : $PMS_LOG_DIR"
    _pms_message "info"  "PMS_LOCAL            : $PMS_LOCAL"
    _pms_message "info"  "PMS_DEBUG            : $PMS_DEBUG"
    _pms_message "info"  "PMS_REPO             : $PMS_REPO"
    _pms_message "info"  "PMS_REMOTE           : $PMS_REMOTE"
    _pms_message "info"  "PMS_BRANCH           : $PMS_BRANCH"
    _pms_message "info"  "PMS_THEME            : $PMS_THEME"
    _pms_message "info"  "PMS_PLUGINS          : ${PMS_PLUGINS[*]}"
    _pms_message "info"  "PMS_SHELL            : $PMS_SHELL\n"
fi

####
# Load all enabled plugins
####
for plugin in "${PMS_PLUGINS[@]}"; do
    if [ "$plugin" != "$PMS_SHELL" ] && [ "$plugin" != "pms" ]; then
        _pms_time "$plugin" _pms_plugin_load "$plugin"
    fi
done
unset plugin
####

####
# Load Theme
####
_pms_theme_load "$PMS_THEME"
####
