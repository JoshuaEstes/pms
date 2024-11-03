####
# PMS
#
# This is the main entry point for PMS.
####

# Validate we can properly configure the shell
# @todo Ensure that its a supported shell
if [ -z $1 ]; then
    echo
    echo "Usage: pms.sh PMS_SHELL"
    echo
    exit 1
fi
PMS_SHELL=$1

if [ -z $PMS ]; then
    echo "The PMS variable is not set. I have no fucking idea what you want me to load."
    exit 1
fi

# We want to make sure that ALL the PMS variables are set if the user does not
# set them in one of the env files
source $PMS/plugins/pms/env
if [ "1" -eq "$PMS_DEBUG" ]; then
    echo "source $PMS/plugins/pms/env"
fi

# If the shell has any variables that need to be set, we need to make sure they
# get set
source $PMS/plugins/$PMS_SHELL/env
if [ "1" -eq "$PMS_DEBUG" ]; then
    echo "source $PMS/plugins/$PMS_SHELL/env"
fi

####
# This will load up libraries from the code base. It will load sh and then load
# specific shell libraries
#
# @internal
####
for lib in $PMS/lib/*.{sh,$PMS_SHELL}; do
    # @todo load all local libraries
    source $lib
    if [ "1" -eq "$PMS_DEBUG" ]; then
        echo "source $lib"
    fi
done
unset lib

_pms_source_file ~/.pms.plugins
_pms_source_file ~/.pms.theme

# Load the PMS and SHELL plugins
_pms_plugin_load pms $PMS_SHELL

if [ "$PMS_DEBUG" -eq "1" ]; then
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
    _pms_message "info"  "PMS_SHELL            : $PMS_SHELL"
    _pms_message "info"  "PMS_DOTFILES_REPO    : $PMS_DOTFILES_REPO"
    _pms_message "info"  "PMS_DOTFILES_REMOTE  : $PMS_DOTFILES_REMOTE"
    _pms_message "info"  "PMS_DOTFILES_BRANCH  : $PMS_DOTFILES_BRANCH"
    _pms_message "info"  "PMS_DOTFILES_GIT_DIR : $PMS_DOTFILES_GIT_DIR\n"
fi

####
# Load all enabled plugins
####
for plugin in "${PMS_PLUGINS[@]}"; do
    if [[ "$plugin" != "$PMS_SHELL" && "$plugin" != "pms" ]]; then
        _pms_plugin_load $plugin
    fi
done
unset plugin
####

####
# Load Theme
####
_pms_theme_load $PMS_THEME
####
