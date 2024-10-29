####
# PMS
#
# One framework to manage your Themes, Plugins, and dotfiles
####

# Validate we can properly configure the shell
if [ -z $1 ]; then
    echo
    echo "Usage: pms.sh PMS_SHELL"
    echo
    exit 1
fi
PMS_SHELL=$1

####
# This will load up libraries from the code base. It will load sh and then load
# specific shell libraries
#
# @todo local overwrites
# @internal
####
for lib in $PMS/lib/*.{sh,$PMS_SHELL}; do
    source $lib
done
unset lib

_pms_source_file $PMS/plugins/pms/env
_pms_source_file ~/.pms.plugins
_pms_source_file ~/.pms.theme
_pms_source_file $PMS/plugins/$PMS_SHELL/env
_pms_plugin_load pms $PMS_SHELL

if [ "$PMS_DEBUG" -eq "1" ]; then
    _pms_message_block "info" "Current PMS Settings"
    _pms_message "info" "PMS:         $PMS"
    _pms_message "info" "PMS_LOCAL:   $PMS_LOCAL"
    _pms_message "info" "PMS_DEBUG:   $PMS_DEBUG"
    _pms_message "info" "PMS_REPO:    $PMS_REPO"
    _pms_message "info" "PMS_REMOTE:  $PMS_REMOTE"
    _pms_message "info" "PMS_BRANCH:  $PMS_BRANCH"
    _pms_message "info" "PMS_THEME:   $PMS_THEME"
    _pms_message "info" "PMS_PLUGINS: ${PMS_PLUGINS[*]}"
    _pms_message "info" "PMS_SHELL:   $PMS_SHELL\n"
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
