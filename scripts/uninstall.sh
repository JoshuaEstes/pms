#!/usr/bin/env bash
set -e
# Set to 1 to skip prompts.
NO_INTERACTION=0

main() {
    while getopts "n" option; do
        case ${option} in
            n)
                NO_INTERACTION=1
                ;;
            *)
                return 1
                ;;
        esac
    done

    # Confirm with user they really want to uninstall PMS
    if [ "$NO_INTERACTION" -eq "0" ]; then
        read -r -p "Are you sure you want to uninstall PMS? [y/N] " confirm
        if [ "${confirm}" != "y" ] && [ "${confirm}" != "Y" ]; then
            echo "Canceled"
            exit
        fi
    fi

    # Revert rc files (user confirmation)
    if [ -f ~/.bashrc.pms.bak ] && [ -f ~/.bashrc ]; then
        if [ "$NO_INTERACTION" -eq "0" ]; then
            read -r -p "Restore your ~/.bashrc with the backup ~/.bashrc.pms.bak? [Y/n] " confirm
            if [ "${confirm}" != "n" ] && [ "${confirm}" != "N" ]; then
                mv ~/.bashrc.pms.bak ~/.bashrc
            fi
        else
            mv ~/.bashrc.pms.bak ~/.bashrc
        fi
    fi
    if [ -f ~/.zshrc.pms.bak ] && [ -f ~/.zshrc ]; then
        if [ "$NO_INTERACTION" -eq "0" ]; then
            read -r -p "Restore your ~/.zshrc with the backup ~/.zshrc.pms.bak? [Y/n] " confirm
            if [ "${confirm}" != "n" ] && [ "${confirm}" != "N" ]; then
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
        if [ "$NO_INTERACTION" -eq "0" ]; then
            read -r -p "Would you like to delete ~/.env file? [Y/n] " confirm
            if [ "${confirm}" != "n" ] && [ "${confirm}" != "N" ]; then
                rm -fv ~/.env
            fi
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
