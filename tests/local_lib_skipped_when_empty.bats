#!/usr/bin/env bats
# shellcheck shell=bash

setup() {
    pms_root="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"
    export PMS="$pms_root"
    export PMS_LOCAL="$BATS_TEST_TMPDIR/local"
    mkdir -p "$PMS_LOCAL/lib"
    export PMS_SHELL="bash"
    export PMS_DEBUG=1
    export PMS_THEME=default
    export HOME="$BATS_TEST_TMPDIR/home"
    mkdir -p "$HOME"
}

@test "pms.sh skips local libraries when none present" {
    run bash "$PMS/pms.sh" "$PMS_SHELL"
    [ "$status" -eq 0 ]
    case "$output" in
        *"$PMS_LOCAL/lib"*) false ;;
        *) ;;
    esac
}
