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

set -e
# Set to 1 to skip prompts.
UNINSTALL_NO_INTERACTION=0
PMS_INSTALL_DIR=${PMS_INSTALL_DIR:-$HOME/.pms}

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
            exit
        fi
    fi

    # Revert rc files (user confirmation)
    if [ -f ~/.bashrc.pms.bak ] && [ -f ~/.bashrc ]; then
        if [ "$UNINSTALL_NO_INTERACTION" -eq "0" ]; then
            read -r -p "Restore your ~/.bashrc with the backup ~/.bashrc.pms.bak? [Y/n] " user_response
            if [ "$user_response" != "n" ] && [ "$user_response" != "N" ]; then
                mv ~/.bashrc.pms.bak ~/.bashrc
            fi
        else
            mv ~/.bashrc.pms.bak ~/.bashrc
        fi
    fi
    if [ -f ~/.zshrc.pms.bak ] && [ -f ~/.zshrc ]; then
        if [ "$UNINSTALL_NO_INTERACTION" -eq "0" ]; then
            read -r -p "Restore your ~/.zshrc with the backup ~/.zshrc.pms.bak? [Y/n] " user_response
            if [ "$user_response" != "n" ] && [ "$user_response" != "N" ]; then
                mv ~/.zshrc.pms.bak ~/.zshrc
            fi
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
        if [ "$UNINSTALL_NO_INTERACTION" -eq "0" ]; then
            read -r -p "Would you like to delete ~/.env file? [Y/n] " user_response
            if [ "$user_response" != "n" ] && [ "$user_response" != "N" ]; then
                rm -fv ~/.env
            fi
        else
            rm -fv ~/.env
        fi
    fi

    # Delete PMS directory
    echo "Removing $PMS_INSTALL_DIR directory"
    rm -rf "$PMS_INSTALL_DIR"

    echo "PMS has been uninstalled. You should restart your terminal"
}

main "$@"
