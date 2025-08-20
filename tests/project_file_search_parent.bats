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

@test "_pms_project_file_load searches parent directories" {
    parent="$BATS_TEST_TMPDIR/parent"
    mkdir -p "$parent/sub"
    cat <<'EOP' > "$parent/.pms"
PMS_THEME=solarized
EOP
    pushd "$parent/sub" >/dev/null
    PMS_THEME=""
    _pms_project_file_load
    status=$?
    [ "$status" -eq 0 ]
    [ "$PMS_THEME" = "solarized" ]
    popd >/dev/null
}
