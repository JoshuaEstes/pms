#!/usr/bin/env bats
# shellcheck shell=bash

setup() {
    pms_root="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"
    export PMS="$pms_root"
    export PMS_LOCAL="$BATS_TEST_TMPDIR/local"
    mkdir -p "$PMS_LOCAL/plugins"
    export PMS_DEBUG=0
    export PMS_THEME=default
    export HOME="$BATS_TEST_TMPDIR/home"
    mkdir -p "$HOME"
}

@test "pms.sh loads libraries when sourced in zsh" {
    run zsh -c "source \"$PMS/pms.sh\" zsh >/dev/null && type _pms_source_file >/dev/null"
    [ "$status" -eq 0 ]
}
