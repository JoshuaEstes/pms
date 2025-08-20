#!/usr/bin/env bats
# shellcheck shell=bash

setup() {
    pms_root="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"
    export PMS="$pms_root"
}

@test "HISTSIZE defaults to 10000" {
    run zsh -c "unset HISTSIZE; source \"$PMS/plugins/zsh/env\"; printf '%s\n' \"\$HISTSIZE\""
    [ "$status" -eq 0 ]
    [ "${lines[0]}" -eq 10000 ]
}
