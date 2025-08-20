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

@test "pms.sh exits successfully for supported shell" {
    run bash "$PMS/pms.sh" bash
    [ "$status" -eq 0 ]
}
