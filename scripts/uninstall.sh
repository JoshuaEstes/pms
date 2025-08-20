#!/usr/bin/env bash
set -e
# set to 1 to not ask user any questions
NO_INTERACTION=0
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=../lib/core.sh
. "$SCRIPT_DIR/../lib/core.sh"

main() {
    while getopts "n" o; do
        case ${o} in
            n)
                NO_INTERACTION=1
                ;;
            *)
                return 1
                ;;
        esac
    done

    # Confirm with user they really want to uninstall PMS
    if [ "$NO_INTERACTION" -eq 0 ]; then
        confirm=$(_pms_prompt "Are you sure you want to uninstall PMS? [y/N]" "n" "[yYnN]")
        case "$confirm" in
            y|Y) ;;
            *) echo "Canceled"; exit 0;;
        esac
    fi

    # Revert rc files (user confirmation)
    if [ -f ~/.bashrc.pms.bak ] && [ -f ~/.bashrc ]; then
        if [ "$NO_INTERACTION" -eq 0 ]; then
            confirm=$(_pms_prompt "Restore your ~/.bashrc with the backup ~/.bashrc.pms.bak? [Y/n]" "y" "[yYnN]")
            case "$confirm" in
                y|Y) mv ~/.bashrc.pms.bak ~/.bashrc;;
            esac
        else
            mv ~/.bashrc.pms.bak ~/.bashrc
        fi
    fi
    if [ -f ~/.zshrc.pms.bak ] && [ -f ~/.zshrc ]; then
        if [ "$NO_INTERACTION" -eq 0 ]; then
            confirm=$(_pms_prompt "Restore your ~/.zshrc with the backup ~/.zshrc.pms.bak? [Y/n]" "y" "[yYnN]")
            case "$confirm" in
                y|Y) mv ~/.zshrc.pms.bak ~/.zshrc;;
            esac
        else
            mv ~/.zshrc.pms.bak ~/.zshrc
        fi
    fi

    # Delete PMS Config files
    echo "Removing ~/.pms.theme file"
    rm -fv ~/.pms.theme
    echo "Removing ~/.pms.plugins file"
    rm -fv ~/.pms.plugins

    # Delete .env (user confirmation)
    if [ -f ~/.env ]; then
        if [ "$NO_INTERACTION" -eq 0 ]; then
            confirm=$(_pms_prompt "Would you like to delete ~/.env file? [Y/n]" "y" "[yYnN]")
            case "$confirm" in
                y|Y) rm -fv ~/.env;;
            esac
        else
            rm -fv ~/.env
        fi
    fi

    # Delete $PMS directory
    echo "Removing ~/.pms directory"
    rm -rf ~/.pms

    echo "PMS has been uninstalled. You should restart your terminal"
}

main "$@"
