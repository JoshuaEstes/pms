# vim: set ft=sh:
# shellcheck shell=sh
####
# Disable plugins installed with the joshuaestes theme.
# Prompts for confirmation unless UNINSTALL_NO_INTERACTION=1.
####

if [ "${UNINSTALL_NO_INTERACTION:-0}" -eq 0 ]; then
    printf 'Disable plugins vcs-info, vim-mode, and php? [y/N] '
    read -r disable_plugins
    if [ "$disable_plugins" != "y" ] && [ "$disable_plugins" != "Y" ]; then
        echo "Canceled"
        return
    fi
fi

pms plugin disable vcs-info >/dev/null 2>&1 || true
pms plugin disable vim-mode >/dev/null 2>&1 || true
pms plugin disable php >/dev/null 2>&1 || true
