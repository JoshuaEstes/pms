#!/usr/bin/env bats
# shellcheck shell=bash

# Verify that _pms_message applies blue color for info type.
setup() {
    pms_root="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"
    export PMS="$pms_root"
    # shellcheck disable=SC2034
    color_blue="<blue>"
    # shellcheck disable=SC2034
    color_green="<green>"
    # shellcheck disable=SC2034
    color_yellow="<yellow>"
    # shellcheck disable=SC2034
    color_red="<red>"
    # shellcheck disable=SC2034
    color_reset="<reset>"
    # shellcheck source=../lib/core/interactive.sh disable=SC1091
    source "$PMS/lib/core/interactive.sh"
}

@test "message formats info with colors" {
    run _pms_message info "Info text"
    [ "$status" -eq 0 ]
    [ "$output" = $'\r<blue>Info text<reset>\n' ]
}
