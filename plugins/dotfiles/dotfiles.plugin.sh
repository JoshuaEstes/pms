# vim: set ft=sh:
# shellcheck shell=bash
####
# Dotfiles Plugin
#
# Provides commands for managing user dotfiles via a git repository.
####

# Dispatch dotfiles subcommands
__pms_command_dotfiles() {
    [[ $# -gt 0 ]] || {
        __pms_command_help_dotfiles
        return 1
    }

    local subcommand="$1"
    shift

    type "__pms_command_dotfiles_${subcommand}" >/dev/null 2>&1 && {
        "__pms_command_dotfiles_${subcommand}" "$@"
        return $?
    }

    __pms_command_help_dotfiles
    return 1
}

# Display help information for dotfiles commands
__pms_command_help_dotfiles() {
    echo
    echo "Usage: pms [options] dotfiles <command>"
    echo
    echo "Commands:"
    __pms_command "push" "Push changes"
    __pms_command "add [file] [file] ..." "Add file(s) to your repository (commit and push)"
    __pms_command "git <command>" "Runs the git command (example: pms dotfiles git status)"
    echo
    return 0
}

# Pushes committed dotfiles to the remote repository
__pms_command_dotfiles_push() {
    git --git-dir="$PMS_DOTFILES_GIT_DIR" --work-tree="$HOME" -C "$HOME" push origin "$PMS_DOTFILES_BRANCH"
}

# Adds and commits dotfiles
__pms_command_dotfiles_add() {
    local tracked_files=( "$@" )
    if [ $# -eq 0 ]; then
        # shellcheck disable=SC2207
        tracked_files=( $(git --git-dir="$PMS_DOTFILES_GIT_DIR" --work-tree="$HOME" -C "$HOME" diff --name-only --diff-filter=MD) )
    fi
    if [ "${#tracked_files[@]}" -eq 0 ]; then
        _pms_message "error" "Nothing to do"
        return 1
    fi
    local file
    for file in "${tracked_files[@]}"; do
        git --git-dir="$PMS_DOTFILES_GIT_DIR" --work-tree="$HOME" -C "$HOME" add --verbose --force "$file"
    done
    git --git-dir="$PMS_DOTFILES_GIT_DIR" --work-tree="$HOME" -C "$HOME" commit -m "Update dotfiles"
    __pms_command_dotfiles_push
}

# Runs arbitrary git command within the dotfiles repository
__pms_command_dotfiles_git() {
    git --git-dir="$PMS_DOTFILES_GIT_DIR" --work-tree="$HOME" -C "$HOME" "$@"
}
