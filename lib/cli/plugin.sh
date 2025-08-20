# vim: set ft=sh:
# shellcheck shell=bash
####
# Plugin commands for PMS CLI.
####

# Dispatch plugin subcommands.
__pms_command_plugin() {
    [ $# -gt 0 ] || {
        __pms_command_help_plugin
        return 1
    }

    local command=$1
    shift

    if type "__pms_command_plugin_${command}" >/dev/null 2>&1; then
        "__pms_command_plugin_${command}" "$@"
        return $?
    fi

    __pms_command_help_plugin
    return 1
}

# Show help for plugin commands.
__pms_command_help_plugin() {
    echo
    echo "Usage: pms [options] plugin <command>"
    echo
    echo "Commands:"
    __pms_command "list" "Lists all available plugins"
    __pms_command "search [term]" "Searches the plugin index"
    __pms_command "install <code|repo>" "Installs a plugin from the index or a Git repository"
    __pms_command "enable <plugin>" "Enables and installs a plugin"
    __pms_command "disable <plugin>" "Disables a plugin"
    __pms_command "info <plugin>" "Displays information about a plugin"
    __pms_command "update <plugin>" "Fetches the latest version of a plugin"
    __pms_command "make <plugin>" "Creates a new plugin"
    echo
    _pms_message "Examples:"
    _pms_message_block "pms help plugin enable"
    _pms_message_block "pms help plugin list"
    echo

    return 0
}

# Show help for 'plugin list'.
__pms_command_help_plugin_list() {
    echo
    echo "Usage: pms plugin list"
    echo
    echo "Lists all available plugins with their versions."
    echo

    return 0
}

# Show help for 'plugin search'.
__pms_command_help_plugin_search() {
    echo
    echo "Usage: pms plugin search [term]"
    echo
    echo "Searches the plugin index for matching plugins."
    echo "Set PMS_PLUGIN_INDEX to override the default index file."
    echo
    return 0
}

# Show help for 'plugin install'.
__pms_command_help_plugin_install() {
    echo
    echo "Usage: pms plugin install <code|repo>"
    echo
    echo "Installs a plugin by code from the plugin index or directly from a Git repository and enables it."
    echo
    return 0
}

# Show help for 'plugin enable'.
__pms_command_help_plugin_enable() {
    echo
    echo "Usage: pms plugin enable <plugin>"
    echo
    echo "Enables and installs the specified plugin."
    echo

    return 0
}

# Show help for 'plugin disable'.
__pms_command_help_plugin_disable() {
    echo
    echo "Usage: pms plugin disable <plugin>"
    echo
    echo "Disables the specified plugin."
    echo

    return 0
}

# Show help for 'plugin info'.
__pms_command_help_plugin_info() {
    echo
    echo "Usage: pms plugin info <plugin>"
    echo
    echo "Displays information about a plugin."
    echo

    return 0
}

# Show help for 'plugin update'.
__pms_command_help_plugin_update() {
    echo
    echo "Usage: pms plugin update <plugin>"
    echo
    echo "Fetches the latest commit for the specified plugin."
    echo
    return 0
}

# Show help for 'plugin make'.
__pms_command_help_plugin_make() {
    echo
    echo "Usage: pms plugin make <plugin>"
    echo
    echo "Creates a new plugin scaffold."
    echo

    return 0
}

# Create a new plugin scaffold.
__pms_command_plugin_make() {
    if [ -z "$1" ]; then
        _pms_message_block "error" "Usage: pms plugin make <plugin>"
        return 1
    fi
    local plugin="$1"

    if [ -d "$PMS/plugins/$plugin" ]; then
        _pms_message_block "error" "Plugin $plugin already exists"
        return 1
    fi

    mkdir -vp "$PMS/plugins/$plugin"
    cp -v "$PMS/templates/plugin"/* "$PMS/plugins/$plugin/"
    mv "$PMS/plugins/$plugin/skeleton.plugin.bash" "$PMS/plugins/$plugin/$plugin.plugin.bash"
    mv "$PMS/plugins/$plugin/skeleton.plugin.sh" "$PMS/plugins/$plugin/$plugin.plugin.sh"
    mv "$PMS/plugins/$plugin/skeleton.plugin.zsh" "$PMS/plugins/$plugin/$plugin.plugin.zsh"

    _pms_message_block "success" "Plugin Created"

    return 0
}

# Fetch plugin index from a file or URL.
_pms_plugin_index_fetch() {
    local index="${PMS_PLUGIN_INDEX:-$PMS/plugins.txt}"

    if printf '%s\n' "$index" | grep -qE '^https?://'; then
        curl -fsSL "$index"
    else
        cat "$index"
    fi
}

# Lookup plugin information by code.
_pms_plugin_index_lookup() {
    local code="$1" line
    line=$(_pms_plugin_index_fetch | grep "^${code}|" ) || true
    [ -n "$line" ] || return 1
    printf '%s\n' "$line"
}

# Search the plugin index for a term.
__pms_command_plugin_search() {
    local query="$1"
    local data

    if ! data=$(_pms_plugin_index_fetch); then
        _pms_message_block "error" "Unable to fetch plugin index"
        return 1
    fi

    echo
    printf "\r  %-12s %-20s %-40s %s\n" "Code" "Name" "Description" "Repository"
    while IFS='|' read -r code name description repo; do
        [ -z "$code" ] && continue
        case "$code" in
            \#*) continue ;;
        esac
        if [ -z "$query" ] || printf '%s %s %s %s\n' "$code" "$name" "$description" "$repo" | grep -iq "$query"; then
            printf "\r  %-12s %-20s %-40s %s\n" "$code" "$name" "$description" "$repo"
        fi
    done <<EOF
$data
EOF
    echo

    return 0
}

# Install a plugin from the index or a repository.
__pms_command_plugin_install() {
    if [ -z "$1" ]; then
        _pms_message_block "error" "Usage: pms plugin install <code|repo>"
        return 1
    fi

    local identifier="$1" plugin repo line
    line=$(_pms_plugin_index_lookup "$identifier") || true
    if [ -n "$line" ]; then
        IFS='|' read -r plugin _ _ repo <<EOF
$line
EOF
    else
        repo="$identifier"
        plugin=$(basename "$repo")
        plugin=${plugin%.git}
    fi

    if [ -d "$PMS_LOCAL/plugins/$plugin" ] || [ -d "$PMS/plugins/$plugin" ]; then
        _pms_message "error" "Plugin '$plugin' already exists"
        return 1
    fi

    _pms_message "info" "Cloning '$repo'"
    if ! git clone "$repo" "$PMS_LOCAL/plugins/$plugin"; then
        _pms_message "error" "Failed to clone repository"
        rm -rf "$PMS_LOCAL/plugins/$plugin"
        return 1
    fi

    _pms_plugin_get_version "$PMS_LOCAL/plugins/$plugin" >/dev/null

    __pms_command_plugin_enable "$plugin"

    return $?
}

# Retrieve plugin version information.
_pms_plugin_get_version() {
    local dir="$1"
    local version_file="$dir/.pms-version"
    local version

    if [ -f "$version_file" ]; then
        read -r version < "$version_file"
    elif git -C "$dir" rev-parse HEAD >/dev/null 2>&1; then
        version=$(git -C "$dir" rev-parse HEAD)
        echo "$version" > "$version_file"
    else
        version="unknown"
    fi

    printf '%s' "${version:0:7}"
}

# List plugins and their versions, marking enabled ones.
__pms_command_plugin_list() {
    echo
    printf "\r  %-30s %s\n" "Plugin" "Version"
    local plugin_dir plugin version enabled
    for plugin_dir in "$PMS"/plugins/* "$PMS_LOCAL"/plugins/*; do
        [ -d "$plugin_dir" ] || continue
        plugin=${plugin_dir##*/}
        version=$(_pms_plugin_get_version "$plugin_dir")
        if _pms_is_plugin_enabled "$plugin"; then
            enabled="*"
        else
            enabled=" "
        fi
        printf "\r%c %-30s %s\n" "$enabled" "$plugin" "$version"
    done
    echo

    return 0
}

# Update an installed plugin.
__pms_command_plugin_update() {
    if [ -z "$1" ]; then
        _pms_message_block "error" "Usage: pms plugin update <plugin>"
        return 1
    fi
    local plugin="$1" dir

    if [ -d "$PMS_LOCAL/plugins/$plugin" ]; then
        dir="$PMS_LOCAL/plugins/$plugin"
    elif [ -d "$PMS/plugins/$plugin" ]; then
        dir="$PMS/plugins/$plugin"
    else
        _pms_message "error" "Plugin '$plugin' not found"
        return 1
    fi

    _pms_message "info" "Updating '$plugin'"
    git -C "$dir" pull --ff-only

    _pms_plugin_get_version "$dir" >/dev/null

    return 0
}

# Enable a plugin, optionally using fzf.
__pms_command_plugin_enable() {
    local plugin="$1"

    if [ -z "$plugin" ]; then
        if [ "$PMS_HAS_FZF" -eq 1 ]; then
            local available_plugins=()
            local plugin_dir
            for plugin_dir in "$PMS"/plugins/* "$PMS_LOCAL"/plugins/*; do
                [ -d "$plugin_dir" ] || continue
                plugin_dir=${plugin_dir##*/}
                if ! _pms_is_plugin_enabled "$plugin_dir"; then
                    available_plugins+=("$plugin_dir")
                fi
            done
            plugin=$(printf '%s\n' "${available_plugins[@]}" | sort | fzf --prompt="Plugin> ")
            if [ -z "$plugin" ]; then
                _pms_message "error" "No plugin selected"
                return 1
            fi
        else
            _pms_message "error" "A plugin name is required"
            return 1
        fi
    fi

    if [ ! -d "$PMS_LOCAL/plugins/$plugin" ] && [ ! -d "$PMS/plugins/$plugin" ]; then
        _pms_message "error" "The plugin '$plugin' is invalid and cannot be enabled"
        return 1
    fi

    if _pms_is_plugin_enabled "$plugin"; then
        _pms_message "error" "The plugin '$plugin' is already enabled"
        return 1
    fi

    _pms_message "info" "Adding '$plugin' to ~/.pms.plugins"
    PMS_PLUGINS+=("$plugin")
    echo "PMS_PLUGINS=(${PMS_PLUGINS[*]})" > "$HOME/.pms.plugins"

    _pms_message "info" "Checking for plugin install script"
    if [ -f "$PMS_LOCAL/plugins/$plugin/install.sh" ]; then
        _pms_source_file "$PMS_LOCAL/plugins/$plugin/install.sh"
    elif [ -f "$PMS/plugins/$plugin/install.sh" ]; then
        _pms_source_file "$PMS/plugins/$plugin/install.sh"
    fi

    if [ -f "$PMS_LOCAL/plugins/$plugin/install.$PMS_SHELL" ]; then
        _pms_source_file "$PMS_LOCAL/plugins/$plugin/install.$PMS_SHELL"
    elif [ -f "$PMS/plugins/$plugin/install.$PMS_SHELL" ]; then
        _pms_source_file "$PMS/plugins/$plugin/install.$PMS_SHELL"
    fi

    _pms_message "info" "Loading plugin"
    _pms_time "$plugin" _pms_plugin_load "$plugin"

    return 0
}

# Disable a plugin.
__pms_command_plugin_disable() {
    local plugin="$1"

    local _plugin_enabled=0
    for p in "${PMS_PLUGINS[@]}"; do
        if [ "$p" = "${plugin}" ]; then
            _plugin_enabled=1
        fi
    done
    if [ "$_plugin_enabled" -eq 0 ]; then
        _pms_message_section "error" "$plugin" "The plugin is not enabled"
        return 1
    fi

    local _plugins=()
    for i in "${PMS_PLUGINS[@]}"; do
        if [ "$i" != "$plugin" ]; then
            _plugins+=("$i")
        fi
    done
    PMS_PLUGINS=("${_plugins[@]}")
    echo "PMS_PLUGINS=(${_plugins[*]})" > "$HOME/.pms.plugins"
    _pms_source_file "$HOME/.pms.plugins"

    if [ -f "$PMS_LOCAL/plugins/$plugin/uninstall.sh" ]; then
        _pms_source_file "$PMS_LOCAL/plugins/$plugin/uninstall.sh"
    elif [ -f "$PMS/plugins/$plugin/uninstall.sh" ]; then
        _pms_source_file "$PMS/plugins/$plugin/uninstall.sh"
    fi

    if [ -f "$PMS_LOCAL/plugins/$plugin/uninstall.$PMS_SHELL" ]; then
        _pms_source_file "$PMS_LOCAL/plugins/$plugin/uninstall.$PMS_SHELL"
    elif [ -f "$PMS/plugins/$plugin/uninstall.$PMS_SHELL" ]; then
        _pms_source_file "$PMS/plugins/$plugin/uninstall.$PMS_SHELL"
    fi

    _pms_message_section "success" "$plugin" "Plugin has been disabled, you will need to reload pms by running 'pms reload'"

    return 0
}

# Display plugin information.
__pms_command_plugin_info() {
    if [ -f "$PMS/plugins/$1/README.md" ]; then
        cat "$PMS/plugins/$1/README.md"
    else
        _pms_message_block "error" "Plugin $1 has no README.md file"

        return 1
    fi

    return 0
}
