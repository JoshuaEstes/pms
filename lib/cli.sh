# vim: set ft=sh:
# shellcheck shell=bash
####
# This file contains the PMS script that manages everything
#
# Core PMS commands start with "__pms_command_*"
# For plugins, the command must start with "__pms_command_{plugin}_*" and
# MUST include a "__pms_command_help_{plugin}_*" function
####
# shellcheck source=lib/cli/theme.sh disable=SC1090
. "$PMS/lib/cli/theme.sh"

# shellcheck source=lib/cli/plugin.sh disable=SC1090
. "$PMS/lib/cli/plugin.sh"

# Primary PMS command dispatcher.

pms() {
    [ $# -gt 0 ] || {
        __pms_command_help
        return 1
    }

    local command=$1
    shift

    type "__pms_command_${command}" >/dev/null 2>&1 && {
        __pms_command_"${command}" "$@"
        return $?
    }

    __pms_command_help
    return 1
}

# Format command descriptions for help output.
__pms_command() {
    printf "\r  %-30s %s\n" "$1" "$2"
}

# Display PMS branding and project information.
__pms_command_about() {
    # shellcheck disable=SC2154
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
    # shellcheck disable=SC2154
    echo "${color_reset}"
    echo "Making you more productive in your shell than a turtle"
    echo
    echo "Source: https://github.com/JoshuaEstes/pms"
    echo "Docs:   https://docs.codewithjoshua.com/pms"
    echo

    return 0
}

# Display help for commands and subcommands.
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
            __pms_command "${plugin}"
        }
    done

    echo
    _pms_message "Some commands provide additional help. You can access that by running:"
    _pms_message_block "pms help <command> [subcommand]"

    echo
    return 0
}

# Detect if fzf is available for interactive selections
if command -v fzf >/dev/null 2>&1; then
    PMS_HAS_FZF=1
else
    PMS_HAS_FZF=0
fi

# Change the user's shell.
__pms_command_chsh() {
    if [ -z "$1" ]; then
        echo
        echo "Please specify the shell to switch to."
        echo
        echo "Usage: pms chsh zsh"
        echo
        cat /etc/shells
        return 1
    fi

    if [ -f "/bin/$1" ]; then
        chsh -s "/bin/$1"
    else
        _pms_message_block "error" "$1 is not a valid shell"
    fi

    return 0
}

# Output diagnostic information about the environment.
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
    if [ -d "$PMS" ]; then
        echo "Hash                 : $(cd "$PMS" || exit; git rev-parse --short HEAD)"
    else
        echo "Hash                 : PMS not installed"
    fi
    echo
    echo "-=[ Contents of ~/.pms.theme ]=-"
    cat "$HOME/.pms.theme"
    echo
    echo "-=[ Contents of ~/.pms.plugins ]=-"
    cat "$HOME/.pms.plugins"
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

# Copy a file with verbose output and error handling.
#
# Usage:
#   _pms_file_copy SOURCE DESTINATION
_pms_file_copy() {
    if [ $# -ne 2 ]; then
        _pms_message "error" "Usage: _pms_file_copy <source> <destination>"
        return 1
    fi

    local source_file="$1"
    local destination_file="$2"

    if ! cp -v "$source_file" "$destination_file"; then
        _pms_message "error" "Failed to copy '$source_file' to '$destination_file'"
        return 1
    fi

    return 0
}

# Upgrade PMS to the latest version.
__pms_command_upgrade() {
    local checkpoint="$PWD"

    if ! cd "$PMS"; then
        _pms_message "error" "Unable to change directory to '$PMS'"
        return 1
    fi

    _pms_message_block "info" "Upgrading to latest PMS version"
    if ! git pull origin main; then
        _pms_message "error" "Error pulling down updates..."
        cd "$checkpoint" || return 1
        return 1
    fi

    _pms_message_block "info" "Copying files"
    _pms_file_copy "$PMS/templates/bashrc" "$HOME/.bashrc"
    _pms_file_copy "$PMS/templates/zshrc" "$HOME/.zshrc"
    _pms_message_block "info" "Running update scripts for enabled plugins..."

    local plugin
    for plugin in "${PMS_PLUGINS[@]}"; do
        if [ -f "$PMS_LOCAL/plugins/$plugin/update.sh" ]; then
            _pms_message_section "info" "$plugin (local)" "plugin updating..."
            # shellcheck source=/dev/null
            source "$PMS_LOCAL/plugins/$plugin/update.sh"
        elif [ -f "$PMS/plugins/$plugin/update.sh" ]; then
            _pms_message_section "info" "$plugin" "plugin updating..."
            # shellcheck source=/dev/null
            source "$PMS/plugins/$plugin/update.sh"
        fi
    done

    _pms_message_block "info" "Completed update scripts"
    _pms_message_block "success" "Upgrade complete, you may need to reload your environment (pms reload)"

    cd "$checkpoint" || return 1
    __pms_command_reload

    return 0
}

# Reload the current shell.
__pms_command_reload() {
    case "$-" in
        *i*) exec -l "$SHELL" ;;
        *) exec "$SHELL" ;;
    esac
}

