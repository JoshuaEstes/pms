#!/usr/bin/env sh
#
# Installs the dotfiles plugin by initializing the dotfiles repository if needed.
set -e

if [ ! -d "$PMS_DOTFILES_GIT_DIR" ]; then
    git init --bare "$PMS_DOTFILES_GIT_DIR"
    git --git-dir="$PMS_DOTFILES_GIT_DIR" --work-tree="$HOME" -C "$HOME" config --local status.showUntrackedFiles no
fi
