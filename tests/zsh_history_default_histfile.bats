#!/usr/bin/env bats
# shellcheck shell=bash

setup() {
    pms_root="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"
    export PMS="$pms_root"
}

@test "HISTFILE defaults to \$HOME/.zsh_history" {
    run zsh -c "unset HISTFILE; export HOME=\"$BATS_TEST_TMPDIR\"; \
        source \"$PMS/plugins/zsh/env\"; printf '%s\n' \"\$HISTFILE\""
    [ "$status" -eq 0 ]
    [ "${lines[0]}" = "$BATS_TEST_TMPDIR/.zsh_history" ]
}
