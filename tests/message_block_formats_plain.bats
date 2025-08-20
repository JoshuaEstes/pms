#!/usr/bin/env bats
# shellcheck shell=bash

# Verify that _pms_message_block prints plain text when no type is given.
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

@test "message_block formats plain text when type absent" {
    run _pms_message_block "Notice"
    [ "$status" -eq 0 ]
    [ "$output" = $'\r\n\tNotice\n\n' ]
}
