# vim: set ft=sh:
# shellcheck shell=bash
####
# Theme commands for PMS CLI.
####

# Dispatch theme subcommands.
__pms_command_theme() {
    [ $# -gt 0 ] || {
        __pms_command_help_theme
        return 1
    }

    local command=$1
    shift

    if type "__pms_command_theme_${command}" >/dev/null 2>&1; then
        "__pms_command_theme_${command}" "$@"
        return $?
    fi

    __pms_command_help_theme

    return 1
}

# Show help for theme commands.
__pms_command_help_theme() {
    echo
    echo "Usage: pms [options] theme <command>"
    echo
    echo "Commands:"
    __pms_command "list" "Displays available themes"
    __pms_command "switch <theme>" "Switch to a specific theme"
    __pms_command "info <theme>" "Displays information about a theme"
    echo
    _pms_message "Examples:"
    _pms_message_block "pms help theme list"
    _pms_message_block "pms help theme switch"
    echo

    return 0
}

# Show help for 'theme list'.
__pms_command_help_theme_list() {
    echo
    echo "Usage: pms theme list"
    echo
    echo "Displays available themes."
    echo

    return 0
}

# Show help for 'theme switch'.
__pms_command_help_theme_switch() {
    echo
    echo "Usage: pms theme switch <theme>"
    echo
    echo "Switches to the specified theme."
    echo

    return 0
}

# Show help for 'theme info'.
__pms_command_help_theme_info() {
    echo
    echo "Usage: pms theme info <theme>"
    echo
    echo "Displays information about a theme."
    echo

    return 0
}

# List available themes and the current selection.
__pms_command_theme_list() {
    _pms_message_block "info" "Core Themes"
    for theme in "$PMS"/themes/*; do
        theme=${theme%*/}
        _pms_message "info" "${theme##*/}"
    done
    _pms_message_block "info" "Local Themes"
    for theme in "$PMS_LOCAL"/themes/*; do
        theme=${theme%*/}
        _pms_message "info" "${theme##*/}"
    done
    _pms_message_block "success" "Current Theme: $PMS_THEME"

    return 0
}

# Switch to a theme, optionally using fzf for selection.
__pms_command_theme_switch() {
    local theme=$1

    if [ -z "$theme" ]; then
        if [ "$PMS_HAS_FZF" -eq 1 ]; then
            local available_themes=()
            local theme_dir
            for theme_dir in "$PMS"/themes/* "$PMS_LOCAL"/themes/*; do
                [ -d "$theme_dir" ] || continue
                theme_dir=${theme_dir##*/}
                available_themes+=("$theme_dir")
            done
            theme=$(printf '%s\n' "${available_themes[@]}" | sort | fzf --prompt="Theme> ")
            if [ -z "$theme" ]; then
                _pms_message "error" "No theme selected"
                return 1
            fi
        else
            _pms_message "error" "A theme name is required"
            return 1
        fi
    fi

    if [ ! -d "$PMS_LOCAL/themes/$theme" ] && [ ! -d "$PMS/themes/$theme" ]; then
        _pms_message "error" "The theme '$theme' is invalid"
        return 1
    fi

    if [ -f "$PMS/themes/$PMS_THEME/uninstall.sh" ]; then
        _pms_source_file "$PMS/themes/$PMS_THEME/uninstall.sh"
    fi
    echo "PMS_THEME=$theme" > "$HOME/.pms.theme"
    PMS_THEME=$theme
    if [ -f "$PMS/themes/$theme/install.sh" ]; then
        _pms_source_file "$PMS/themes/$theme/install.sh"
    fi
    _pms_theme_load "$theme"

    return 0
}

# Display information about a theme.
__pms_command_theme_info() {
    if [ -f "$PMS/themes/$1/README.md" ]; then
        cat "$PMS/themes/$1/README.md"
    else
        _pms_message_block "error" "Theme $1 has no README.md file"

        return 1
    fi

    return 0
}
