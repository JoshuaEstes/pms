# vim: set ft=sh:
# shellcheck shell=bash
####
# This file contains the PMS script that manages everything
#
# Core PMS commands start with "__pms_command_*"
# For plugins, the command must start with "__pms_command_{plugin}_*" and
# MUST include a "__pms_command_help_{plugin}_*" function
####

pms() {
    [[ $# -gt 0 ]] || {
        __pms_command_help
        return 1
    }

    local command=$1
    shift

    type __pms_command_${command} &>/dev/null && {
        __pms_command_${command} "$@"
        return $?
    }

    __pms_command_help
    return 1
}

__pms_command() {
    printf "\r  %-30s %s\n" "$1" "$2"
}

__pms_command_about() {
    echo "${color_green}"
cat <<-'EOF'

 _______   __                                __       __                   ______   __                  __  __
/       \ /  |                              /  \     /  |                 /      \ /  |                /  |/  |
$$$$$$$  |$$/  _____  ____    ______        $$  \   /$$ | __    __       /$$$$$$  |$$ |____    ______  $$ |$$ |
$$ |__$$ |/  |/     \/    \  /      \       $$$  \ /$$$ |/  |  /  |      $$ \__$$/ $$      \  /      \ $$ |$$ |
$$    $$/ $$ |$$$$$$ $$$$  |/$$$$$$  |      $$$$  /$$$$ |$$ |  $$ |      $$      \ $$$$$$$  |/$$$$$$  |$$ |$$ |
$$$$$$$/  $$ |$$ | $$ | $$ |$$ |  $$ |      $$ $$ $$/$$ |$$ |  $$ |       $$$$$$  |$$ |  $$ |$$    $$ |$$ |$$ |
$$ |      $$ |$$ | $$ | $$ |$$ |__$$ |      $$ |$$$/ $$ |$$ \__$$ |      /  \__$$ |$$ |  $$ |$$$$$$$$/ $$ |$$ |
$$ |      $$ |$$ | $$ | $$ |$$    $$/       $$ | $/  $$ |$$    $$ |      $$    $$/ $$ |  $$ |$$       |$$ |$$ |
$$/       $$/ $$/  $$/  $$/ $$$$$$$/        $$/      $$/  $$$$$$$ |       $$$$$$/  $$/   $$/  $$$$$$$/ $$/ $$/
                            $$ |                         /  \__$$ |
                            $$ |                         $$    $$/
                            $$/                           $$$$$$/

EOF
    echo "${color_reset}"
    echo "Making you more productive in your shell than a turtle"
    echo
    echo "Source: https://github.com/JoshuaEstes/pms"
    echo "Docs:   https://docs.codewithjoshua.com/pms"
    echo

    return 0
}

# Display help for commands and subcommands
__pms_command_help() {
    if [ $# -gt 0 ]; then
        local command=$1
        shift

        if [ $# -gt 0 ]; then
            local subcommand=$1
            shift

            type __pms_command_help_"${command}"_"${subcommand}" &>/dev/null && {
                __pms_command_help_"${command}"_"${subcommand}" "$@"
                return $?
            }

            set -- "$subcommand" "$@"
        fi

        type __pms_command_help_"${command}" &>/dev/null && {
            __pms_command_help_"${command}" "$@"
            return $?
        }
    fi

    echo
    echo "Usage: pms [options] <command>"
    echo
    echo "Commands:"
    __pms_command "theme" "Helps to manage themes"
    __pms_command "plugin" "Helps to manage plugins"
    __pms_command "chsh <shell>" "Change shell"
    __pms_command "about" "Show PMS information"
    __pms_command "upgrade" "Upgrade PMS to latest version"
    __pms_command "diagnostic" "Outputs diagnostic information"
    __pms_command "reload" "Reloads all of PMS"

    local plugin
    for plugin in "${PMS_PLUGINS[@]}"; do
        type __pms_command_help_"${plugin}" &>/dev/null && {
            __pms_command_help_"${plugin}" "$@"
            return $?
        }
    done

    echo
    _pms_message "Some commands provide additional help. You can access that by running:"
    _pms_message_block "pms help <command> [subcommand]"

    echo
    return 0
}

# @todo make sure it is a supported shell
__pms_command_chsh() {
    if [ -z "$1" ]; then
        echo
        echo "What fucking shell you want to change to?"
        echo
        echo "Usage: pms chsh zsh"
        echo
        cat /etc/shells
        return 1
    fi

    if [ -f "/bin/$1" ]; then
        chsh -s "/bin/$1"
    else
        _pms_message_block "error" "$1 is not fucking shell, try again..."
    fi

    return 0
}

__pms_command_diagnostic() {
    # @todo Alert user to any known issues with configurations
    # @todo output to log file
    echo
    echo "-=[ PMS ]=-"
    echo "PMS                  : $PMS"
    echo "PMS_CACHE_DIR        : $PMS_CACHE_DIR"
    echo "PMS_LOG_DIR          : $PMS_LOG_DIR"
    echo "PMS_LOCAL            : $PMS_LOCAL"
    echo "PMS_DEBUG            : $PMS_DEBUG"
    echo "PMS_REPO             : $PMS_REPO"
    echo "PMS_REMOTE           : $PMS_REMOTE"
    echo "PMS_BRANCH           : $PMS_BRANCH"
    echo "PMS_THEME            : $PMS_THEME"
    echo "PMS_PLUGINS          : ${PMS_PLUGINS[*]}"
    echo "PMS_SHELL            : $PMS_SHELL"
    echo "PMS_DOTFILES_REPO    : $PMS_DOTFILES_REPO"
    echo "PMS_DOTFILES_REMOTE  : $PMS_DOTFILES_REMOTE"
    echo "PMS_DOTFILES_BRANCH  : $PMS_DOTFILES_BRANCH"
    echo "PMS_DOTFILES_GIT_DIR : $PMS_DOTFILES_GIT_DIR"
    if [ "${#PMS_PLUGIN_TIME_NAMES[@]}" -gt 0 ]; then
        echo
        echo "-=[ Plugin Timings ]=-"
        local timing_index
        for timing_index in "${!PMS_PLUGIN_TIME_NAMES[@]}"; do
            printf "%-20s : %s ms\n" "${PMS_PLUGIN_TIME_NAMES[$timing_index]}" "${PMS_PLUGIN_TIME_VALUES[$timing_index]}"
        done
    fi
    if [ -d $PMS ]; then
        echo "Hash                 : $(cd $PMS; git rev-parse --short HEAD)"
    else
        echo "Hash                 : PMS not installed"
    fi
    echo
    echo "-=[ Contents of ~/.pms.theme ]=-"
    cat ~/.pms.theme
    echo
    echo "-=[ Contents of ~/.pms.plugins ]=-"
    cat ~/.pms.plugins
    echo
    echo "-=[ Shell ]=-"
    echo "SHELL                : $SHELL"
    case "$PMS_SHELL" in
      bash) echo "BASHOPTS             : $BASHOPTS" ;;
      zsh) echo "ZSH_PATHCLEVEL       : $ZSH_PATCHLEVEL" ;;
    esac
    echo
    echo "-=[ Terminal ]=-"
    echo "TERM                 : $TERM"
    echo "TERM_PROGRAM         : $TERM_PROGRAM"
    echo "TERM_PROGRAM_VERSION : $TERM_PROGRAM_VERSION"
    echo
    echo "-=[ OS ]=-"
    echo "OSTYPE               : $OSTYPE"
    echo "USER                 : $USER"
    echo "umask                : $(umask)"
    case "$OSTYPE" in
      darwin*)
        echo "Product Name:     $(sw_vers -productName)"
        echo "Product Version:  $(sw_vers -productVersion)"
        echo "Build Version:    $(sw_vers -buildVersion)"
        ;;
      linux*) echo "Release: $(lsb_release -s -d)" ;;
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
    echo "-=[ Aliases ]=-"
    alias
    echo
    echo "-=[ Metadata ]=-"
    echo "Generated At: $(date)"

    return 0
}

__pms_command_upgrade() {
  local checkpoint=$PWD
  cd "$PMS"
  _pms_message_block "info" "Upgrading to latest PMS version"
  git pull origin main || {
      _pms_message "error" "Error pulling down updates..."
      cd "$checkpoint"
      return 1
  }
  _pms_message_block "info" "Copying files"
  # @todo _pms_file_copy <src> <dest>
  cp -v $PMS/templates/bashrc ~/.bashrc
  cp -v $PMS/templates/zshrc ~/.zshrc
  _pms_message_block "info" "Running update scripts for enabled plugins..."

  local plugin
  for plugin in "${PMS_PLUGINS[@]}"; do
    if [ -f $PMS_LOCAL/plugins/$plugin/update.sh ]; then
        _pms_message_section "info" "$plugin (local)" "plugin updating..."
        source $PMS_LOCAL/plugins/$plugin/update.sh
    elif [ -f $PMS/plugins/$plugin/update.sh ]; then
        _pms_message_section "info" $plugin "plugin updating..."
        source $PMS/plugins/$plugin/update.sh
    fi
  done
  _pms_message_block "info" "Completed update scripts"
  _pms_message_block "success" "Upgrade complete, you may need to reload your environment (pms reload)"
  cd "$checkpoint"
  __pms_command_reload

    return 0
}

__pms_command_reload() {
    #_pms_message "Are you sure you want to reload PMS? (y/n) "
    #if ! _pms_question_yn; then
    #    return 1
    #fi

    #_pms_message_block "info" "Reloading PMS..."
    if [[ $- == *i* ]]; then
        # shell is interactive
        exec -l $SHELL
    else
        exec $SHELL
    fi
    #source ~/.${PMS_SHELL}rc
    #exec "$SHELL" --login
    #sh $PMS/pms.sh $PMS_SHELL $PMS_DEBUG
    #_pms_message_block "success" "Completed"
}

__pms_command_theme() {
    [[ $# -gt 0 ]] || {
        __pms_command_help_theme
        return 1
    }

    local command=$1
    shift

    type __pms_command_theme_${command} &>/dev/null && {
        __pms_command_theme_${command} "$@"
        return $?
    }

    __pms_command_help_theme

    return 1
}

__pms_command_help_theme() {
    echo
    echo "Usage: pms [options] theme <command>"
    echo
    echo "Commands:"
    __pms_command "list" "Displays available themes"
    __pms_command "switch <theme>" "Switch to a specific theme"
    __pms_command "info <theme>" "Displays information about a theme"
    #echo "  reload             Reloads current theme"
    #echo "  use <theme>        Temporary use theme"
    #echo "  preview <theme>    Preview theme"
    #echo "  validate <theme>   Validate theme"
    #echo "  make <theme>       Creates a new theme"
    echo
    _pms_message "Examples:"
    _pms_message_block "pms help theme list"
    _pms_message_block "pms help theme switch"
    echo

    # @todo Allow plugins to hook into this

    return 0
}

__pms_command_help_theme_list() {
    echo
    echo "Usage: pms theme list"
    echo
    echo "Displays available themes."
    echo

    return 0
}

__pms_command_help_theme_switch() {
    echo
    echo "Usage: pms theme switch <theme>"
    echo
    echo "Switches to the specified theme."
    echo

    return 0
}

__pms_command_help_theme_info() {
    echo
    echo "Usage: pms theme info <theme>"
    echo
    echo "Displays information about a theme."
    echo

    return 0
}

__pms_command_theme_list() {
    _pms_message_block "info" "Core Themes"
    for theme in $PMS/themes/*; do
        theme=${theme%*/}
        _pms_message "info" "${theme##*/}"
    done
    _pms_message_block "info" "Local Themes"
    for theme in $PMS_LOCAL/themes/*; do
        theme=${theme%*/}
        _pms_message "info" "${theme##*/}"
    done
    _pms_message_block "success" "Current Theme: $PMS_THEME"

    return 0
}

__pms_command_theme_switch() {
    local theme=$1

    # Does theme exist?
    if [ ! -d $PMS_LOCAL/themes/$theme ] && [ ! -d $PMS/themes/$theme ]; then
        _pms_message "error" "The theme '$theme' is invalid"
        return 1
    fi
    # @todo make all this better and support PMS_LOCAL
    if [ -f $PMS/themes/$PMS_THEME/uninstall.sh ]; then
        _pms_source_file $PMS/themes/$PMS_THEME/uninstall.sh
    fi
    echo "PMS_THEME=$theme" > ~/.pms.theme
    PMS_THEME=$theme
    # @todo make all this better and support PMS_LOCAL
    if [ -f $PMS/themes/$theme/install.sh ]; then
        _pms_source_file $PMS/themes/$theme/install.sh
    fi
    _pms_theme_load $theme

    return 0
}

__pms_command_theme_info() {
    if [ -f $PMS/themes/$1/README.md ]; then
        cat $PMS/themes/$1/README.md
    else
        _pms_message_block "error" "Theme $1 has no README.md file"

        return 1
    fi

    return 0
}

__pms_command_plugin() {
    [[ $# -gt 0 ]] || {
        __pms_command_help_plugin
        return 1
    }

    local command=$1
    shift

    type __pms_command_plugin_${command} &>/dev/null && {
        __pms_command_plugin_${command} "$@"
        return $?
    }

    __pms_command_help_plugin
    return 1
}

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
    #echo "  validate <plugin>  Validate plugin"
    #echo "  reload <plugin>    Reloads enabled plugins"
    echo
    _pms_message "Examples:"
    _pms_message_block "pms help plugin enable"
    _pms_message_block "pms help plugin list"
    echo

    # @todo allow plugins to hook into this

    return 0
}

__pms_command_help_plugin_list() {
    echo
    echo "Usage: pms plugin list"
    echo
    echo "Lists all available plugins with their versions."
    echo

    return 0
}

__pms_command_help_plugin_search() {
    echo
    echo "Usage: pms plugin search [term]"
    echo
    echo "Searches the plugin index for matching plugins."
    echo "Set PMS_PLUGIN_INDEX to override the default index file."
    echo
    return 0
}

__pms_command_help_plugin_install() {
    echo
    echo "Usage: pms plugin install <code|repo>"
    echo
    echo "Installs a plugin by code from the plugin index or directly from a Git repository and enables it."
    echo
    return 0
}

__pms_command_help_plugin_enable() {
    echo
    echo "Usage: pms plugin enable <plugin>"
    echo
    echo "Enables and installs the specified plugin."
    echo

    return 0
}

__pms_command_help_plugin_disable() {
    echo
    echo "Usage: pms plugin disable <plugin>"
    echo
    echo "Disables the specified plugin."
    echo

    return 0
}

__pms_command_help_plugin_info() {
    echo
    echo "Usage: pms plugin info <plugin>"
    echo
    echo "Displays information about a plugin."
    echo

    return 0
}

__pms_command_help_plugin_update() {
    echo
    echo "Usage: pms plugin update <plugin>"
    echo
    echo "Fetches the latest commit for the specified plugin."
    echo
    return 0
}

__pms_command_help_plugin_make() {
    echo
    echo "Usage: pms plugin make <plugin>"
    echo
    echo "Creates a new plugin scaffold."
    echo

    return 0
}

# @todo Option for making this a local plugin
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

# Fetch plugin index from a file or URL
_pms_plugin_index_fetch() {
    local index="${PMS_PLUGIN_INDEX:-$PMS/plugins.txt}"

    if printf '%s\n' "$index" | grep -qE '^https?://' ; then
        curl -fsSL "$index"
    else
        cat "$index"
    fi
}

# Lookup plugin information by code
_pms_plugin_index_lookup() {
    local code="$1" line
    line=$(_pms_plugin_index_fetch | grep "^${code}\\|" || true)
    [ -n "$line" ] || return 1
    printf '%s\n' "$line"
}

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

__pms_command_plugin_list() {
    local plugin version
    echo
    echo "Core Plugins:"
    for plugin in "$PMS"/plugins/*; do
        plugin=${plugin##*/}
        version=$(_pms_plugin_get_version "$PMS/plugins/$plugin")
        if _pms_is_plugin_enabled "$plugin"; then
            printf "\r  %-20s %-8s [enabled]\n" "$plugin" "$version"
        else
            printf "\r  %-20s %s\n" "$plugin" "$version"
        fi
    done
    echo
    echo "Local Plugins:"
    for plugin in "$PMS_LOCAL"/plugins/*; do
        plugin=${plugin##*/}
        version=$(_pms_plugin_get_version "$PMS_LOCAL/plugins/$plugin")
        if _pms_is_plugin_enabled "$plugin"; then
            printf "\r  %-20s %-8s [enabled]\n" "$plugin" "$version"
        else
            printf "\r  %-20s %s\n" "$plugin" "$version"
        fi
    done
    echo

    return 0
}

__pms_command_plugin_update() {
    local plugin="$1"
    local path

    if [ -z "$plugin" ]; then
        _pms_message_block "error" "Usage: pms plugin update <plugin>"
        return 1
    fi

    if [ -d "$PMS_LOCAL/plugins/$plugin/.git" ]; then
        path="$PMS_LOCAL/plugins/$plugin"
    elif [ -d "$PMS/plugins/$plugin/.git" ]; then
        path="$PMS/plugins/$plugin"
    else
        _pms_message_block "error" "Plugin '$plugin' is not a git repository"
        return 1
    fi

    _pms_message "info" "Updating '$plugin'"
    if git -C "$path" pull --ff-only; then
        _pms_plugin_get_version "$path" >/dev/null
        _pms_message_section "success" "$plugin" "Plugin updated"
        return 0
    fi

    _pms_message "error" "Failed to update '$plugin'"
    return 1
}

# @todo support for multiple plugins at a time
__pms_command_plugin_enable() {
    local plugin="$1"
    # Does directory exist?
    if [ ! -d "$PMS_LOCAL/plugins/$plugin" ] && [ ! -d "$PMS/plugins/$plugin" ]; then
        _pms_message "error" "The plugin '$plugin' is invalid and cannot be enabled"
        return 1
    fi

    # Check plugin is not already enabled
    if _pms_is_plugin_enabled "$plugin"; then
        _pms_message "error" "The plugin '$plugin' is already enabled"
        return 1
    fi

    # @todo if plugin cannot be loaded, do not do this
    _pms_message "info" "Adding '$plugin' to ~/.pms.plugins"
    PMS_PLUGINS+=("$plugin")
    echo "PMS_PLUGINS=(${PMS_PLUGINS[*]})" > "$HOME/.pms.plugins"

    _pms_message "info" "Checking for plugin install script"
    if [ -f "$PMS_LOCAL/plugins/$plugin/install.sh" ]; then
        _pms_source_file "$PMS_LOCAL/plugins/$plugin/install.sh"
    elif [ -f "$PMS/plugins/$plugin/install.sh" ]; then
        _pms_source_file "$PMS/plugins/$plugin/install.sh"
    fi

    # Shell specific install
    if [ -f "$PMS_LOCAL/plugins/$plugin/install.$PMS_SHELL" ]; then
        _pms_source_file "$PMS_LOCAL/plugins/$plugin/install.$PMS_SHELL"
    elif [ -f "$PMS/plugins/$plugin/install.$PMS_SHELL" ]; then
        _pms_source_file "$PMS/plugins/$plugin/install.$PMS_SHELL"
    fi

    _pms_message "info" "Loading plugin"
    _pms_time "$plugin" _pms_plugin_load "$plugin"

  return 0
}

__pms_command_plugin_disable() {
    local plugin="$1"

    # @todo support for multiple plugins at a time
    local _plugin_enabled=0

    # Check to see if the plugin is already enabled and if so, notify user and
    # exit
    for p in "${PMS_PLUGINS[@]}"; do
        if [ "$p" = "${plugin}" ]; then
            _plugin_enabled=1
        fi
    done
    if [ "$_plugin_enabled" -eq 0 ]; then
        _pms_message_section "error" "$plugin" "The plugin is not enabled"
        return 1
    fi
    # ---

    # Remove from plugins
    local _plugins=()
    for i in "${PMS_PLUGINS[@]}"; do
        if [ "$i" != "$plugin" ]; then
            _plugins+=("$i")
        fi
    done
    PMS_PLUGINS=("${_plugins[@]}")
    # save .pms.plugins
    echo "PMS_PLUGINS=(${_plugins[*]})" > "$HOME/.pms.plugins"
    _pms_source_file "$HOME/.pms.plugins"

    # Run uninstall script (if available)
    if [ -f "$PMS_LOCAL/plugins/$plugin/uninstall.sh" ]; then
        _pms_source_file "$PMS_LOCAL/plugins/$plugin/uninstall.sh"
    elif [ -f "$PMS/plugins/$plugin/uninstall.sh" ]; then
        _pms_source_file "$PMS/plugins/$plugin/uninstall.sh"
    fi

    # Shell specific
    if [ -f "$PMS_LOCAL/plugins/$plugin/uninstall.$PMS_SHELL" ]; then
        _pms_source_file "$PMS_LOCAL/plugins/$plugin/uninstall.$PMS_SHELL"
    elif [ -f "$PMS/plugins/$plugin/uninstall.$PMS_SHELL" ]; then
        _pms_source_file "$PMS/plugins/$plugin/uninstall.$PMS_SHELL"
    fi

    _pms_message_section "success" "$plugin" "Plugin has been disabled, you will need to reload pms by running 'pms reload'"
    # @todo Ask user to reload environment

  return 0
}

__pms_command_plugin_info() {
    if [ -f "$PMS/plugins/$1/README.md" ]; then
        cat "$PMS/plugins/$1/README.md"
    else
        _pms_message_block "error" "Plugin $1 has no README.md file"

        return 1
    fi

    return 0
}

