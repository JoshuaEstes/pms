autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' check-for-staged-changes true
zstyle ':vcs_info:git+*:*' debug false
zstyle ':vcs_info:git:*' get-revision true
zstyle ':vcs_info:git:*' formats '%b (%7.7i) <%u%c%m>'
zstyle ':vcs_info:git+set-message:*' hooks git-untracked
zstyle ':vcs_info:*+no-vcs:*' hooks no-vcs-detected
+vi-git-untracked() {
    if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]] && \
        git status --porcelain | grep '??' &> /dev/null ; then
        hook_com[staged]+='T'
    fi

    if [[ $hook_com[staged] == '' && $hook_com[unstaged] == '' ]]; then
        hook_com[misc]+='clean'
    fi
}
+vi-no-vcs-detected() {
    vcs_info_msg_0_='no vcs'
}
