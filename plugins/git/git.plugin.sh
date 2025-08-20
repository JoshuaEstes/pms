# vim: set ft=sh:
# shellcheck shell=sh
####
# Plugin: git
####
alias g='git'
alias gd='git d'
alias gs='git s'
alias gr='git r'

git_global_ignore_file="${GIT_GLOBAL_IGNORE_FILE:-$HOME/.config/git/ignore}"

git_setup_global_ignore() {
    mkdir -p "$(dirname "$git_global_ignore_file")"
    touch "$git_global_ignore_file"

    current_excludes_file="$(git config --global core.excludesFile 2>/dev/null || true)"
    if [ "$current_excludes_file" != "$git_global_ignore_file" ]; then
        git config --global core.excludesFile "$git_global_ignore_file"
    fi
}

git_global_ignore_update() {
    if [ "$#" -eq 0 ]; then
        printf '%s\n' "Usage: git_global_ignore_update <Template> [Template...]" >&2
        return 1
    fi

    git_setup_global_ignore || return 1
    : >"$git_global_ignore_file"

    for template in "$@"; do
        url="https://raw.githubusercontent.com/github/gitignore/main/Global/${template}.gitignore"
        if ! curl -fsSL "$url" >>"$git_global_ignore_file"; then
            printf '%s\n' "Failed to download template: $template" >&2
            return 1
        fi
        printf '\n' >>"$git_global_ignore_file"
    done
}

alias ggiu='git_global_ignore_update'

git_setup_global_ignore
