#!/usr/bin/env bats
# shellcheck shell=bash

@test "uninstall aborts on uppercase N" {
    HOME="$BATS_TMPDIR"
    touch "$HOME/.pms.theme"
    run bash -c "printf 'N\n' | scripts/uninstall.sh"
    [ "$status" -eq 0 ]
    [ -f "$HOME/.pms.theme" ]
    case "$output" in
        *Canceled*) ;;
        *) false ;;
    esac
}
