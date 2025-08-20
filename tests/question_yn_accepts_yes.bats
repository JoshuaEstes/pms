#!/usr/bin/env bats
# shellcheck shell=bash

# Verify that _pms_question_yn returns success when user answers yes.
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

# Feed a positive answer and expect a zero exit status.
ask_yes() {
    printf 'y\n' | _pms_question_yn
}

@test "question_yn returns success on yes" {
    run ask_yes
    [ "$status" -eq 0 ]
    [ -z "$output" ]
}
