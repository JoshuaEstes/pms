# shellcheck shell=bash
####
# Theme and plugin loading helpers for PMS
####

####
# Load the active theme for the current shell.
#
# Usage:
#   _pms_theme_load [THEME]
####
_pms_theme_load() {
    _pms_message_section "info" "theme" "Loading '$PMS_THEME' theme"
    local theme_loaded=0
    if [ -f "$PMS_LOCAL/themes/$PMS_THEME/$PMS_THEME.theme.sh" ]; then
        _pms_source_file "$PMS_LOCAL/themes/$PMS_THEME/$PMS_THEME.theme.sh"
        theme_loaded=1
    elif [ -f "$PMS/themes/$PMS_THEME/$PMS_THEME.theme.sh" ]; then
        _pms_source_file "$PMS/themes/$PMS_THEME/$PMS_THEME.theme.sh"
        theme_loaded=1
    fi

    if [ -f "$PMS_LOCAL/themes/$PMS_THEME/$PMS_THEME.theme.$PMS_SHELL" ]; then
        _pms_source_file "$PMS_LOCAL/themes/$PMS_THEME/$PMS_THEME.theme.$PMS_SHELL"
        theme_loaded=1
    elif [ -f "$PMS/themes/$PMS_THEME/$PMS_THEME.theme.$PMS_SHELL" ]; then
        _pms_source_file "$PMS/themes/$PMS_THEME/$PMS_THEME.theme.$PMS_SHELL"
        theme_loaded=1
    fi

    if [ "$theme_loaded" -eq 0 ]; then
        _pms_message "error" "Theme '$PMS_THEME' could not be loaded, loading the 'default' theme"
        _pms_theme_load default
    fi
}

####
# Load one or more plugins.
#
# Usage:
#   _pms_plugin_load plugin [plugin...]
####
_pms_plugin_load() {
    local plugin
    for plugin in "$@"; do
        _pms_message_section "info" "plugin" "Loading '$plugin'"
        local plugin_loaded=0
        local plugin_directory=""

        if [ -d "$PMS_LOCAL/plugins/$plugin" ]; then
            plugin_directory="$PMS_LOCAL/plugins/$plugin"
        elif [ -d "$PMS/plugins/$plugin" ]; then
            plugin_directory="$PMS/plugins/$plugin"
        fi

        if [ "$PMS_SHELL" = "zsh" ] \
            && [ -n "$plugin_directory" ] \
            && [ -d "$plugin_directory/completions" ]; then
            case " ${fpath[*]} " in
                *" $plugin_directory/completions "*) ;;
                *) fpath+=("$plugin_directory/completions") ;;
            esac
        fi

        if [ -f "$PMS_LOCAL/plugins/$plugin/env" ] \
            && [ "$plugin" != "$PMS_SHELL" ] \
            && [ "$plugin" != "pms" ]; then
            _pms_source_file "$PMS_LOCAL/plugins/$plugin/env"
        elif [ -f "$PMS/plugins/$plugin/env" ] \
            && [ "$plugin" != "$PMS_SHELL" ] \
            && [ "$plugin" != "pms" ]; then
            _pms_source_file "$PMS/plugins/$plugin/env"
        fi

        if [ -f "$PMS_LOCAL/plugins/$plugin/$plugin.plugin.sh" ]; then
            _pms_source_file "$PMS_LOCAL/plugins/$plugin/$plugin.plugin.sh"
            plugin_loaded=1
        elif [ -f "$PMS/plugins/$plugin/$plugin.plugin.sh" ]; then
            _pms_source_file "$PMS/plugins/$plugin/$plugin.plugin.sh"
            plugin_loaded=1
        fi

        if [ -f "$PMS_LOCAL/plugins/$plugin/$plugin.plugin.$PMS_SHELL" ]; then
            _pms_source_file "$PMS_LOCAL/plugins/$plugin/$plugin.plugin.$PMS_SHELL"
            plugin_loaded=1
        elif [ -f "$PMS/plugins/$plugin/$plugin.plugin.$PMS_SHELL" ]; then
            _pms_source_file "$PMS/plugins/$plugin/$plugin.plugin.$PMS_SHELL"
            plugin_loaded=1
        fi

        if [ "$plugin_loaded" -eq 0 ]; then
            _pms_message_section "error" "plugin" "Plugin '$plugin' could not be loaded"
        fi
    done
}

####
# Check if a plugin is enabled.
#
# Usage:
#   _pms_is_plugin_enabled "docker"
#
# Returns 0 if enabled, 1 otherwise.
####
_pms_is_plugin_enabled() {
    local plugin_to_check="$1"
    if [ "$plugin_to_check" = "pms" ]; then
        return 0
    fi

    local enabled_plugin
    # Iterate over plugins whether PMS_PLUGINS is an array or a plain string
    # shellcheck disable=SC2068
    for enabled_plugin in ${PMS_PLUGINS[@]}; do
        if [ "$enabled_plugin" = "$plugin_to_check" ]; then
            return 0
        fi
    done
    return 1
}

