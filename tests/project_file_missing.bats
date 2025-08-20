#!/usr/bin/env bats
# shellcheck shell=bash

setup() {
    pms_root="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"
    export PMS="$pms_root"
    export PMS_LOCAL="$BATS_TEST_TMPDIR/local"
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
}

@test "_pms_project_file_load returns failure when no project file" {
    empty_dir="$BATS_TEST_TMPDIR/empty"
    mkdir -p "$empty_dir"
    pushd "$empty_dir" >/dev/null
    status=0
    _pms_project_file_load || status=$?
    [ "$status" -eq 1 ]
    popd >/dev/null
}
