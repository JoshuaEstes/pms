# shellcheck shell=bash
# vim: set ft=sh:
####
# Plugin: dotfiles
####

__pms_command_dotfiles() {
    [[ $# -gt 0 ]] || {
        __pms_command_help_dotfiles
        return 1
    }

    local command="$1"
    shift

    type "__pms_command_dotfiles_${command}" >/dev/null 2>&1 && {
        "__pms_command_dotfiles_${command}" "$@"
        return $?
    }

    __pms_command_help_dotfiles
    return 1
}

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

__pms_command_dotfiles_push() {
    /usr/bin/git --git-dir="$PMS_DOTFILES_GIT_DIR" --work-tree="$HOME" -C "$HOME" push origin "$PMS_DOTFILES_BRANCH"
}

__pms_command_dotfiles_init() {
    # @todo
    # 1. Ask if user wants to start a new repo
    # y) git init, git config, git remote add
    # n) git clone, git config
    # ---
    # Use existing or create new?
    # Existing
    #   git clone --bare REPO_URL $HOME/.dotfiles
    #   git checkout
    #   git config --local status.showUntrackedFiles no
    # Create New
    #   git init --bare $HOME/.dotfiles
    #   git config --local status.showUntrackedFiles no
    #   git remote add origin REPO_URL
    # ---
    :
}

__pms_command_dotfiles_add() {
    local files=("$@")

    if [ $# -eq 0 ]; then
        # Only add files that have been modified or deleted
        # shellcheck disable=SC2207
        files=( $(git --git-dir="$PMS_DOTFILES_GIT_DIR" --work-tree="$HOME" -C "$HOME" diff --name-only --diff-filter=MD) )
    fi

    if [[ "${#files[@]}" -eq 0 ]]; then
        _pms_message "error" "Nothing to do"
        return 1
    fi

    local file
    for file in "${files[@]}"; do
        git --git-dir="$PMS_DOTFILES_GIT_DIR" --work-tree="$HOME" -C "$HOME" add --verbose --force "$file"
    done

    echo "${files[@]}"

    # @todo better commit messages, maybe ask user?
    git --git-dir="$PMS_DOTFILES_GIT_DIR" --work-tree="$HOME" -C "$HOME" commit -m "$file"

    __pms_command_dotfiles_push
}

__pms_command_dotfiles_git() {
    git --git-dir="$PMS_DOTFILES_GIT_DIR" --work-tree="$HOME" -C "$HOME" "$@"
}
