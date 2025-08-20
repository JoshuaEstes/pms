#!/usr/bin/env bash
set -e
# Set to 1 to skip prompts.
NO_INTERACTION=0
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=../lib/core.sh disable=SC1091
. "$SCRIPT_DIR/../lib/core.sh"

main() {
    while getopts "n" opt; do
        case ${opt} in
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
    if [ -f "$HOME/.bashrc.pms.bak" ] && [ -f "$HOME/.bashrc" ]; then
        if [ "$NO_INTERACTION" -eq 0 ]; then
            confirm=$(_pms_prompt "Restore your $HOME/.bashrc with the backup $HOME/.bashrc.pms.bak? [Y/n]" "y" "[yYnN]")
            case "$confirm" in
                y|Y) mv "$HOME/.bashrc.pms.bak" "$HOME/.bashrc";;
            esac
        else
            mv "$HOME/.bashrc.pms.bak" "$HOME/.bashrc"
        fi
    fi
    if [ -f "$HOME/.zshrc.pms.bak" ] && [ -f "$HOME/.zshrc" ]; then
        if [ "$NO_INTERACTION" -eq 0 ]; then
            confirm=$(_pms_prompt "Restore your $HOME/.zshrc with the backup $HOME/.zshrc.pms.bak? [Y/n]" "y" "[yYnN]")
            case "$confirm" in
                y|Y) mv "$HOME/.zshrc.pms.bak" "$HOME/.zshrc";;
            esac
        else
            mv "$HOME/.zshrc.pms.bak" "$HOME/.zshrc"
        fi
    fi

    # Delete PMS Config files
    echo "Removing $HOME/.pms.theme file"
    rm -fv "$HOME/.pms.theme"
    echo "Removing $HOME/.pms.plugins file"
    rm -fv "$HOME/.pms.plugins"

    # Delete .env (user confirmation)
    if [ -f "$HOME/.env" ]; then
        if [ "$NO_INTERACTION" -eq 0 ]; then
            confirm=$(_pms_prompt "Would you like to delete $HOME/.env file? [Y/n]" "y" "[yYnN]")
            case "$confirm" in
                y|Y) rm -fv "$HOME/.env";;
            esac
        else
            rm -fv "$HOME/.env"
        fi
    fi

    # Delete $PMS directory
    echo "Removing $HOME/.pms directory"
    rm -rf "$HOME/.pms"

    echo "PMS has been uninstalled. You should restart your terminal"
}

main "$@"
