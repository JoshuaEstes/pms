#!/usr/bin/env sh
#
# Updates the dotfiles repository.
set -e

git --git-dir="$PMS_DOTFILES_GIT_DIR" --work-tree="$HOME" -C "$HOME" pull origin "$PMS_DOTFILES_BRANCH" >/dev/null 2>&1 || true
