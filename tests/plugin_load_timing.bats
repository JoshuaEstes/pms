#!/usr/bin/env bats

setup() {
    pms_root="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"
    export PMS="$pms_root"
    export PMS_LOCAL="$BATS_TEST_TMPDIR/local"
    mkdir -p "$PMS_LOCAL/plugins/sample"
    touch "$PMS_LOCAL/plugins/sample/sample.plugin.sh"
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

@test "_pms_time records plugin load duration" {
    _pms_time "sample" _pms_plugin_load sample
    [ "${PMS_PLUGIN_TIME_NAMES[0]}" = "sample" ]
    [[ "${PMS_PLUGIN_TIME_VALUES[0]}" -ge 0 ]]
}

@test "__pms_command_diagnostic shows plugin timings" {
    _pms_time "sample" _pms_plugin_load sample
    run __pms_command_diagnostic
    [[ "$output" == *"sample"* ]]
}
