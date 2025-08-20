#!/usr/bin/env bats
# shellcheck shell=bash

setup() {
    pms_root="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"
    export PMS="$pms_root"
}

@test "SAVEHIST defaults to 10000" {
    run zsh -c "unset SAVEHIST; source \"$PMS/plugins/zsh/env\"; printf '%s\n' \"\$SAVEHIST\""
    [ "$status" -eq 0 ]
    [ "${lines[0]}" -eq 10000 ]
}
