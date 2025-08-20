#!/usr/bin/env bats
# shellcheck shell=bash

setup() {
    pms_root="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"
    export PMS="$pms_root"
    export PMS_LOCAL="$BATS_TEST_TMPDIR/local"
    mkdir -p "$PMS_LOCAL/plugins"
    export PMS_SHELL="bash"
    export PMS_DEBUG=0
    export HOME="$BATS_TEST_TMPDIR/home"
    mkdir -p "$HOME"
    git init --bare "$HOME/.dotfiles" >/dev/null
    git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" -C "$HOME" config --local status.showUntrackedFiles no
    git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" -C "$HOME" config user.email test@example.com
    git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" -C "$HOME" config user.name "Test User"
    echo "original" > "$HOME/testfile.txt"
    git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" -C "$HOME" add testfile.txt
    git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" -C "$HOME" commit -m "initial commit" >/dev/null
    echo "modified" > "$HOME/testfile.txt"
    # shellcheck disable=SC2034
    color_blue=""
    # shellcheck disable=SC2034
    color_red=""
    # shellcheck disable=SC2034
    color_green=""
    # shellcheck disable=SC2034
    color_yellow=""
    # shellcheck disable=SC2034
    color_reset=""
    # shellcheck source=../lib/core.sh disable=SC1091
    source "$PMS/lib/core.sh"
    _pms_plugin_load dotfiles
    # shellcheck source=../lib/cli.sh disable=SC1091
    source "$PMS/lib/cli.sh"
}

@test "dotfiles diff shows file changes" {
    run pms dotfiles diff
    [ "$status" -eq 0 ]
    case "$output" in
        *"+modified"*) ;;
        *) false ;;
    esac
}
