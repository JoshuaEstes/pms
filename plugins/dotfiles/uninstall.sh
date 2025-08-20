#!/usr/bin/env sh
#
# Uninstalls the dotfiles plugin by backing up the dotfiles repository.
set -e

if [ -d "$PMS_DOTFILES_GIT_DIR" ]; then
    mv -f "$PMS_DOTFILES_GIT_DIR" "${PMS_DOTFILES_GIT_DIR}.bak"
fi
