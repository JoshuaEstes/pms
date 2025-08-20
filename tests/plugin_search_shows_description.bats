#!/usr/bin/env bats
# shellcheck shell=bash

setup() {
    pms_root="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"
    export PMS="$pms_root"
    export PMS_LOCAL="$BATS_TEST_TMPDIR/local"
    mkdir -p "$PMS_LOCAL/plugins"
    export PMS_SHELL="bash"
    export PMS_DEBUG=0
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
    # shellcheck source=../lib/cli.sh disable=SC1091
    source "$PMS/lib/cli.sh"
}

@test "plugin search shows description" {
    run __pms_command_plugin_search example
    [ "$status" -eq 0 ]
    case "$output" in
        *"Example Plugin"*) ;;
        *) false ;;
    esac
}
