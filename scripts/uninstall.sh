#!/usr/bin/env bash
#
# Uninstall PMS and restore original shell configuration.
#
# Usage:
#   scripts/uninstall.sh [-n]
#
# Options:
#   -n  Run non-interactively and assume "yes" for prompts.
#
# Environment Variables:
#   PMS_INSTALL_DIR  Directory where PMS is installed (default: ~/.pms)
####
# shellcheck shell=bash

set -eu
# Exit on error or undefined variable
set -o pipefail
# Catch failures in pipelines
# Set to 1 to skip prompts.
UNINSTALL_NO_INTERACTION=0
PMS_INSTALL_DIR=${PMS_INSTALL_DIR:-"$HOME/.pms"}

# main orchestrates the uninstallation process.
main() {
    while getopts "n" option; do
        case ${option} in
            n)
                UNINSTALL_NO_INTERACTION=1
                ;;
            *)
                return 1
                ;;
        esac
    done

    # Confirm with user they really want to uninstall PMS
    if [ "$UNINSTALL_NO_INTERACTION" -eq "0" ]; then
        read -r -p "Are you sure you want to uninstall PMS? [y/N] " user_response
        if [ "$user_response" != "y" ] && [ "$user_response" != "Y" ]; then
            echo "Canceled"
            exit 0
        fi
    fi

    # Revert rc files (user confirmation)
    if [ -f "$HOME/.bashrc.pms.bak" ] && [ -f "$HOME/.bashrc" ]; then
        if [ "$UNINSTALL_NO_INTERACTION" -eq "0" ]; then
            read -r -p "Restore your ~/.bashrc with the backup ~/.bashrc.pms.bak? [Y/n] " user_response
            if [ "$user_response" != "n" ] && [ "$user_response" != "N" ]; then
                mv "$HOME/.bashrc.pms.bak" "$HOME/.bashrc"
            fi
        else
            mv "$HOME/.bashrc.pms.bak" "$HOME/.bashrc"
        fi
    fi
    if [ -f "$HOME/.zshrc.pms.bak" ] && [ -f "$HOME/.zshrc" ]; then
        if [ "$UNINSTALL_NO_INTERACTION" -eq "0" ]; then
            read -r -p "Restore your ~/.zshrc with the backup ~/.zshrc.pms.bak? [Y/n] " user_response
            if [ "$user_response" != "n" ] && [ "$user_response" != "N" ]; then
                mv "$HOME/.zshrc.pms.bak" "$HOME/.zshrc"
            fi
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
        if [ "$UNINSTALL_NO_INTERACTION" -eq "0" ]; then
            read -r -p "Would you like to delete ~/.env file? [Y/n] " user_response
            if [ "$user_response" != "n" ] && [ "$user_response" != "N" ]; then
                rm -fv "$HOME/.env"
            fi
        else
            rm -fv "$HOME/.env"
        fi
    fi

    # Delete PMS directory
    echo "Removing $PMS_INSTALL_DIR directory"
    rm -rf "$PMS_INSTALL_DIR"

    echo "PMS has been uninstalled. You should restart your terminal"
}

main "$@"
