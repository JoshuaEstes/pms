#!/usr/bin/env bats
# shellcheck shell=bash

setup() {
    pms_root="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"
    export PMS="$pms_root"
}

@test "HIST_IGNORE_ALL_DUPS defaults to 1" {
    run zsh -c "unset HIST_IGNORE_ALL_DUPS; source \"$PMS/plugins/zsh/env\"; printf '%s\n' \"\$HIST_IGNORE_ALL_DUPS\""
    [ "$status" -eq 0 ]
    [ "${lines[0]}" -eq 1 ]
}
